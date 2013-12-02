require 'set'

module Terrminology
  class FilterOperator < Virtus::Attribute
    VALID_VALUES = Set.new(%w(= is-a is-not-a regex))

    def coerce(value)
      VALID_VALUES.include?(value) ? value : nil
    end
  end
end
