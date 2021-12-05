# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
CORRECT = YAML.safe_load(File.read('spec/fixtures/github_results.yml'))
