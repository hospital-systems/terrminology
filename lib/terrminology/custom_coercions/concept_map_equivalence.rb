module Terrminology
  class ConceptMapEquivalence < Virtus::Attribute
    VALID_VALUES = Set.new(%w(equal equivalent wider narrower inexact unmatched disjoint))

    def coerce(value)
      VALID_VALUES.include?(value) ? value : nil
    end
  end
end
