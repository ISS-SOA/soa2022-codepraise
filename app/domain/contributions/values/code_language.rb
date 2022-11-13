# frozen_string_literal: true

# rubocop:disable Style/Documentation
# rubocop:disable Layout/EmptyLineBetweenDefs
module CodePraise
  module Value
    module CodeLanguage
      WHITESPACE = '[ \t]'
      LINE_END = '$'

      module LanguageMethods
        attr_reader :code

        def initialize(code)
          @code = code
        end

        def name
          self.class.lang_name
        end

        def useless?
          code.match?(self.class.const_get(:USELESS))
        end
      end

      class Ruby
        include LanguageMethods
        def self.lang_name() = 'Ruby'
        COMMENT = '[#\/]'
        USELESS = /^#{WHITESPACE}*(#{COMMENT}|#{LINE_END})/
      end

      class Python
        include LanguageMethods
        def self.lang_name() = 'Python'
        COMMENT = '[#\/]'
        USELESS = /^#{WHITESPACE}*(#{COMMENT}|#{LINE_END})/
      end

      class Javascript
        include LanguageMethods
        def self.lang_name() = 'Javascript'
        COMMENT = '//'
        USELESS = /^#{WHITESPACE}*(#{COMMENT}|#{LINE_END})/
      end

      class Html
        include LanguageMethods
        def self.lang_name() = 'HTML'
        USELESS = /^#{WHITESPACE}*#{LINE_END}/
      end

      class Erb
        include LanguageMethods
        def self.lang_name() = 'ERB'
        USELESS = /^#{WHITESPACE}*#{LINE_END}/
      end

      class Slim
        include LanguageMethods
        def self.lang_name() = 'Slim'
        USELESS = /^#{WHITESPACE}*#{LINE_END}/
      end

      class Css
        include LanguageMethods
        def self.lang_name() = 'CSS'
        USELESS = /^#{WHITESPACE}*#{LINE_END}/
      end

      class Markdown
        include LanguageMethods
        def self.lang_name() = 'Markdown'
        USELESS = /^#{WHITESPACE}*#{LINE_END}/
      end

      class Unknown
        include LanguageMethods
        def useless?() = true
        def self.lang_name() = 'not recognized'
      end

      LANGUAGE_EXTENSION = {
        'rb'   => Ruby,
        'py'   => Python,
        'js'   => Javascript,
        'css'  => Css,
        'html' => Html,
        'erb'  => Erb,
        'slim' => Slim,
        'md'   => Markdown
      }.freeze
      UNKNOWN_LANGUAGE = CodeLanguage::Unknown.freeze

      def self.extension_language(file_extension)
        (LANGUAGE_EXTENSION[file_extension] || UNKNOWN_LANGUAGE)
      end
    end
  end
end
# rubocop:enable Layout/EmptyLineBetweenDefs
# rubocop:enable Style/Documentation
