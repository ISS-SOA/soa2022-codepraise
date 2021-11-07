# frozen_string_literal: false

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'Integration Tests of Github API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from Github to database' do
      project = CodePraise::Github::ProjectMapper
        .new(GITHUB_TOKEN)
        .find(USERNAME, PROJECT_NAME)

      rebuilt = CodePraise::Repository::For.entity(project).create(project)

      _(rebuilt.origin_id).must_equal(project.origin_id)
      _(rebuilt.name).must_equal(project.name)
      _(rebuilt.size).must_equal(project.size)
      _(rebuilt.ssh_url).must_equal(project.ssh_url)
      _(rebuilt.http_url).must_equal(project.http_url)
      _(rebuilt.contributors.count).must_equal(project.contributors.count)

      project.contributors.each do |member|
        found = rebuilt.contributors.find do |potential|
          potential.origin_id == member.origin_id
        end

        _(found.username).must_equal member.username
        # not checking email as it is not always provided
      end
    end
  end
end
