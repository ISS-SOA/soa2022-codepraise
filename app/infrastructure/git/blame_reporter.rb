# frozen_string_literal: true

require 'concurrent'

require_relative 'repo_file'

module CodePraise
  module Git
    # Git contributions report parsing and reporting services
    class BlameReporter
      def initialize(gitrepo, folder_name)
        @local = gitrepo.local
        @folder_name = folder_name
        @folder_name = '' if @folder_name == '/'
      end

      def folder_report
        raise('no files found in folder') if files.empty?

        @local.in_repo do
          files.map do |filename|
            [filename, RepoFile.new(filename).blame]
          end
        end
      end

      def files
        @files ||= @local.files.select { |file| file.start_with? @folder_name }
      end
    end
  end
end
