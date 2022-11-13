# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'contributor'

module CodePraise
  module Entity
    # Entity for a one line of code from a contributor
    class LineContribution
      NO_CREDIT = 0
      FULL_CREDIT = 1

      attr_reader :contributor, :code, :time, :number

      def initialize(contributor:, code:, time:, number:)
        @contributor = contributor
        @code = code
        @time = time
        @number = number
      end

      def credit
        code.useless? ? NO_CREDIT : FULL_CREDIT
      end
    end
  end
end
