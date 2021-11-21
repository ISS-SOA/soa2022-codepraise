# frozen_string_literal: true

require 'figaro'
require 'logger'
require 'rack/session'
require 'roda'
require 'sequel'
# require 'delegate' # needed until Rack 2.3 fixes delegateclass bug

module CodePraise
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_github(recording: :none)
    end

    # Database Setup
    configure :development, :test , :app_test do
      require 'pry'; # for breakpoints
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
    # deliberately :reek:UncommunicativeMethodName calling method DB
    def self.DB = DB # rubocop:disable Naming/MethodName

    # Logger Setup
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER
  end
end
