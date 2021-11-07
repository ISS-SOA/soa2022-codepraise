# frozen_string_literal: true

require_relative 'command'

module CodePraise
  module Git
    # Blame output for a single file
    class RepoFile
      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def blame
        @blame ||= Command.new
          .with_porcelain
          .blame(@filename)
          .call
      end
    end
  end
end
