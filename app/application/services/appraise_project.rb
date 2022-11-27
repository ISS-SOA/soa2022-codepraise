# frozen_string_literal: true

require 'dry/transaction'

module CodePraise
  module Service
    # Analyzes contributions to a project
    class AppraiseProject
      include Dry::Transaction

      step :ensure_watched_project
      step :retrieve_remote_project
      step :clone_remote
      step :appraise_contributions

      private

      # Steps

      def ensure_watched_project(input)
        if input[:watched_list].include? input[:requested].project_fullname
          Success(input)
        else
          Failure('Please first request this project to be added to your list')
        end
      end

      def retrieve_remote_project(input)
        input[:project] = Repository::For.klass(Entity::Project).find_full_name(
          input[:requested].owner_name, input[:requested].project_name
        )

        input[:project] ? Success(input) : Failure('Project not found')
      rescue StandardError
        Failure('Having trouble accessing the database')
      end

      def clone_remote(input)
        gitrepo = GitRepo.new(input[:project])
        gitrepo.clone! unless gitrepo.exists_locally?

        Success(input.merge(gitrepo:))
      rescue StandardError
        App.logger.error error.backtrace.join("\n")
        Failure('Could not clone this project')
      end

      def appraise_contributions(input)
        input[:folder] = Mapper::Contributions
          .new(input[:gitrepo]).for_folder(input[:requested].folder_name)

        Success(input)
      rescue StandardError
        App.logger.error "Could not find: #{full_request_path(input)}"
        Failure('Could not find that folder')
      end

      # Helper methods

      def full_request_path(input)
        [input[:requested].owner_name,
         input[:requested].project_name,
         input[:requested].folder_name].join('/')
      end
    end
  end
end
