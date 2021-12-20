# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require_relative 'helpers'

module CodePraise
  # Web App
  class App < Roda
    include RouteHelpers

    plugin :halt
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

    use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []

        result = Service::ListProjects.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_projects = []
        else
          projects = result.value!.projects
          if projects.none?
            flash.now[:notice] = 'Add a Github project to get started'
          end

          session[:watching] = projects.map(&:fullname)
          viewable_projects = Views::ProjectsList.new(projects)
        end

        view 'home', locals: { projects: viewable_projects }
      end

      routing.on 'project' do
        routing.is do
          # POST /project/
          routing.post do
            url_request = Forms::NewProject.new.call(routing.params)
            project_made = Service::AddProject.new.call(url_request)

            if project_made.failure?
              flash[:error] = project_made.failure
              routing.redirect '/'
            end

            project = project_made.value!
            session[:watching].insert(0, project.fullname).uniq!
            flash[:notice] = 'Project added to your list'
            routing.redirect "project/#{project.owner.username}/#{project.name}"
          end
        end

        routing.on String, String do |owner_name, project_name|
          # DELETE /project/{owner_name}/{project_name}
          routing.delete do
            fullname = "#{owner_name}/#{project_name}"
            session[:watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /project/{owner_name}/{project_name}[/folder_namepath/]
          routing.get do
            path_request = ProjectRequestPath.new(
              owner_name, project_name, request
            )

            session[:watching] ||= []

            result = Service::AppraiseProject.new.call(
              watched_list: session[:watching],
              requested: path_request
            )

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            appraisal = OpenStruct.new(result.value!)

            if appraisal.response.processing?
              flash.now[:notice] = 'The project is being appraised'
            else
              appraised = appraisal.appraised
              proj_folder = Views::ProjectFolderContributions
                .new(appraised[:project], appraised[:folder])

              # Only use browser caching in production
              App.configure :production do
                response.expires 60, public: true
              end
            end

            processing = Views::AppraisalProcessing.new(
              App.config, appraisal.response
            )

            # Show viewer for the project
            view 'project', locals: { proj_folder: proj_folder,
                                      processing: processing }
          end
        end
      end
    end
  end
end
