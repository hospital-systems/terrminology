require 'active_support/core_ext/hash/indifferent_access'

module Terrminology
  class BaseModel
    #TODO: decide if coercion mode should be set to strict
    include Virtus.model
    def primary_key
      "#{self.class.name.split('::').last.underscore}_id"
    end

    def identity
      self.send primary_key
    end

    def ==(other)
      self.send(primary_key) == other.send(primary_key)
    end

    def initialize(attrs)
      attrs = HashWithIndifferentAccess.new(attrs)
      attributes.keys.each do |attr_name|
        self.send("#{attr_name}=", attrs[attr_name])
      end
    end

    def safe_attributes
      attributes.delete_if{|key, value| key.to_s == primary_key }
    end
  end
end
