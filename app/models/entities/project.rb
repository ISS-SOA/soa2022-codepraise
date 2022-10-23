# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

require_relative 'member'

module CodePraise
  module Entity
    # Domain entity for any coding projects
    class Project < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :origin_id, Strict::Integer
      attribute :name,      Strict::String
      attribute :size,      Strict::Integer
      attribute :git_url,   Strict::String
      attribute :owner,     Member
      attribute :members,   Strict::Array.of(Member)
    end
  end
end
