require 'set'

module Terrminology
  class ValueSetStatus < Virtus::Attribute
    def coerce(value)
      Set.new(%w(draft active retired)).include?(value) ? value : nil
    end
  end
end
