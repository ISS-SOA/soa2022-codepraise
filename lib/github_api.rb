# frozen_string_literal: true

require 'http'
require_relative 'project'
require_relative 'contributor'

module CodePraise
  # Library for Github Web API
  class GithubApi
    API_PROJECT_ROOT = 'https://api.github.com/repos'

    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @gh_token = token
    end

    def project(username, project_name)
      project_req_url = gh_api_path([username, project_name].join('/'))
      project_data = call_gh_url(project_req_url).parse
      Project.new(project_data, self)
    end

    def contributors(contributors_url)
      contributors_data = call_gh_url(contributors_url).parse
      contributors_data.map { |account_data| Contributor.new(account_data) }
    end

    private

    def gh_api_path(path)
      "#{API_PROJECT_ROOT}/#{path}"
    end

    def call_gh_url(url)
      result =
        HTTP.headers('Accept' => 'application/vnd.github.v3+json',
                     'Authorization' => "token #{@gh_token}")
            .get(url)

      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
