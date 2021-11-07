# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  # Deliberately :reek:DuplicateMethodCall on App.DB
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    CodePraise::App.DB.run('PRAGMA foreign_keys = OFF')
    CodePraise::Database::MemberOrm.map(&:destroy)
    CodePraise::Database::ProjectOrm.map(&:destroy)
    CodePraise::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
