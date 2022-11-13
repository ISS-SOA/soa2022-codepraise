# frozen_string_literal: true

require_relative 'file_contributions_mapper'

module CodePraise
  module Mapper
    # Summarizes contributions for an entire folder
    class FolderContributions
      attr_reader :folder_name,
                  :contributions_reports

      def initialize(folder_name, contributions_reports)
        @folder_name = folder_name
        @contributions_reports = contributions_reports
      end

      def build_entity
        Entity::FolderContributions.new(
          path: @folder_name,
          files: file_summaries
        )
      end

      def file_summaries
        @contributions_reports.map do |file_report|
          Mapper::FileContributions.new(file_report).build_entity
        end
      end
    end
  end
end
