# frozen_string_literal: true

module CodePraise
  module Mapper
    # Summarizes a single file's contributions by team members
    class BlameContributor
      def initialize(blame_author)
        @username = blame_author['author']
        @email = GitEmail.new(blame_author['author-mail']).strip_brackets
      end

      def to_entity
        Entity::Contributor.new(
          username: @username,
          email: @email
        )
      end
    end

    GitEmail = Struct.new(:email_str) do
      # strip angle brackets <..> around email addresses
      def strip_brackets
        email_str[1..-2]
      end
    end
  end
end
