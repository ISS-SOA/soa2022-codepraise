# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/github_api'

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GITHUB_TOKEN = CONFIG['GITHUB_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/github_results.yml'))

describe 'Tests Github API library' do
  describe 'Project information' do
    it 'HAPPY: should provide correct project attributes' do
      project = CodePraise::GithubApi.new(GITHUB_TOKEN)
                                     .project(USERNAME, PROJECT_NAME)
      _(project.size).must_equal CORRECT['size']
      _(project.git_url).must_equal CORRECT['git_url']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        CodePraise::GithubApi.new(GITHUB_TOKEN).project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::GithubApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Errors::Unauthorized
    end
  end

  describe 'Contributor information' do
    before do
      @project = CodePraise::GithubApi.new(GITHUB_TOKEN)
                                      .project(USERNAME, PROJECT_NAME)
    end

    it 'HAPPY: should recognize owner' do
      _(@project.owner).must_be_kind_of CodePraise::Contributor
    end

    it 'HAPPY: should identify owner' do
      _(@project.owner.username).wont_be_nil
      _(@project.owner.username).must_equal CORRECT['owner']['login']
    end

    it 'HAPPY: should identify contributors' do
      contributors = @project.contributors
      _(contributors.count).must_equal CORRECT['contributors'].count

      usernames = contributors.map(&:username)
      correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
      _(usernames).must_equal correct_usernames
    end
  end
end
