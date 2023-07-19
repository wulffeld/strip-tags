module StripTags
  module Matchers

    # RSpec Examples:
    #
    #   it { is_expected.to strip_tag(:first_name) }
    #   it { is_expected.to strip_tags(:first_name, :last_name) }
    #   it { is_expected.not_to strip_tag(:password) }
    #   it { is_expected.not_to strip_tags(:password, :encrypted_password) }
    #
    # Minitest Matchers Examples:
    #
    #   must { strip_tag(:first_name) }
    #   must { strip_tags(:first_name, :last_name) }
    #   wont { strip_tag(:password) }
    #   wont { strip_tags(:password, :encrypted_password) }
    def strip_tags(*attributes)
      StripTagsMatcher.new(attributes)
    end

    alias_method :strip_tags, :strip_tag

    class StripTagsMatcher
      def initialize(attributes)
        @attributes = attributes
        @options = {}
      end

      def matches?(subject)
        @attributes.all? do |attribute|
          @attribute = attribute
          subject.send("#{@attribute}=", " string ")
          subject.valid?
          subject.send(@attribute) == "string"
        end
      end

      def failure_message # RSpec 3.x
        "Expected whitespace to be #{expectation} from ##{@attribute}, but it was not"
      end
      alias_method :failure_message_for_should, :failure_message # RSpec 1.2, 2.x, and minitest-matchers

      def failure_message_when_negated # RSpec 3.x
        "Expected whitespace to remain on ##{@attribute}, but it was #{expectation}"
      end
      alias_method :failure_message_for_should_not, :failure_message_when_negated # RSpec 1.2, 2.x, and minitest-matchers
      alias_method :negative_failure_message,       :failure_message_when_negated # RSpec 1.1

      def description
        "#{expectation(false)} whitespace from #{@attributes.map {|el| "##{el}" }.to_sentence}"
      end

      private

      def expectation(past = true)
        expectation = past ? "stripped" : "strip"
        expectation += past ? " and replaced" : " and replace"
        expectation
      end
    end
  end
end
