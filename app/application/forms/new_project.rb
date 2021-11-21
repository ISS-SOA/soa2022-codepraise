# frozen_string_literal: true

require 'dry-validation'

module CodePraise
  module Forms
    class NewProject < Dry::Validation::Contract
      URL_REGEX = %r{(http[s]?)\:\/\/(www.)?github\.com\/.*\/.*(?<!git)$}.freeze

      params do
        required(:remote_url).filled(:string)
      end

      rule(:remote_url) do
        unless URL_REGEX.match?(value)
          key.failure('is an invalid address for a Github project')
        end
      end
    end
  end
end
