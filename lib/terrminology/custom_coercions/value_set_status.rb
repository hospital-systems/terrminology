module Terrminology
  class ValueSetStatus < Virtus::Attribute
    VALID_VALUES = Set.new(%w(draft active retired))

    def coerce(value)
      VALID_VALUES.include?(value) ? value : nil
    end
  end
end
