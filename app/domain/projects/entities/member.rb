# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    # Domain entity for team members
    class Member < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :origin_id, Strict::Integer
      attribute :username,  Strict::String
      attribute :email,     Strict::String.optional

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
