require "active_model"
require "action_controller"

module ActiveModel::Validations::HelperMethods
  # Strips tags from model fields.
  def strip_tags(options = {})
    StripTags.validate_options(options)

    before_validation(options.slice(:if, :unless)) do |record|
      StripTags.strip(record, options)
    end
  end
end

module StripTags
  VALID_OPTIONS = [:only, :except, :allow_empty, :regex, :if, :unless].freeze

  def self.strip(record_or_string, options = {})
    if record_or_string.respond_to?(:attributes)
      strip_record(record_or_string, options)
    else
      strip_string(record_or_string, options)
    end
  end

  def self.strip_record(record, options = {})
    attributes = narrow(record.attributes, options)

    attributes.each do |attr, value|
      original_value = value
      value = strip_string(value, options)
      record[attr] = value if original_value != value
    end

    record
  end

  def self.strip_string(value, options = {})
    return value unless value.is_a?(String)
    return value if value.frozen?

    allow_empty = options[:allow_empty]

    value = ActionController::Base.helpers.strip_tags(value).gsub("&amp;", "&").gsub("&gt;", ">").gsub("&lt;", "<")

    (value.blank? && !allow_empty) ? nil : value
  end

  # Necessary because Rails has removed the narrowing of attributes using :only
  # and :except on Base#attributes
  def self.narrow(attributes, options = {})
    if except = options[:except]
      except = Array(except).collect { |attribute| attribute.to_s }
      attributes.except(*except)
    elsif only = options[:only]
      only = Array(only).collect { |attribute| attribute.to_s }
      attributes.slice(*only)
    else
      attributes
    end
  end

  def self.validate_options(options)
    if keys = options.keys
      unless (keys - VALID_OPTIONS).empty?
        raise ArgumentError, "Options does not specify #{VALID_OPTIONS} (#{options.keys.inspect})"
      end
    end
  end
end
