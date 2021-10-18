# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/github_api'

USERNAME = 'soumyaray'
PROJECT_NAME = 'YPBT-app'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GITHUB_TOKEN = CONFIG['GITHUB_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/github_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'github_api'
