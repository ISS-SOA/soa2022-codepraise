# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:projects_members) do
      primary_key [:project_id, :member_id] # rubocop:disable Style/SymbolArray
      foreign_key :project_id, :projects
      foreign_key :member_id, :members

      index [:project_id, :member_id] # rubocop:disable Style/SymbolArray
    end
  end
end
