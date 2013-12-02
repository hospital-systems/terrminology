module Terrminology
  class ConceptMapEquivalence < Virtus::Attribute
    def coerce(value)
      Set.new(%w(equal equivalent wider narrower inexact unmatched disjoint)).include?(value) ? value : nil
    end
  end
end
