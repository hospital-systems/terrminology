module Terrminology
  class CodingBuilder
    def initialize(facade)
      @facade = facade
    end

    def build(target_value_set_identifier, target_code)
      coding  = nil
      concept = find_concept(target_value_set_identifier, target_code)
      coding  = Coding.new(
          system:    nil,
          version:   nil,
          code:      target_code,
          display:   concept.display,
          primary:   nil,
          value_set: target_value_set_identifier
      ) if concept
      coding

      # system:    URI соответствующей code system
      #            оставить пустым?
      #            брать из Named Systems List ( http://www.hl7.org/implement/standards/fhir/terminologies-systems.html ) ?
      #            the system URI SHALL not contain a reference to a value set.
      #            (If the value set defines its own codes, then the correct value for the system is ValueSet.define.system,
      #             and the value set contains a direct reference to the value set resource.)

      # version:   оставить пустым?
      #            в v2 gender и fhir gender version не используется


      # primary:   оставить пустым и не использовать?
      #            A coding may be marked as a "primary" if a user picked the particular coded value explicitly
      #            in a user interface (e.g., the user picks an item in a picklist).
    end

    def find_concept(value_set_identifier, code)
      @facade.concepts(value_set_identifier, code: code).first || @facade.concepts_in_composed(value_set_identifier, code).first
    end
  end
end
