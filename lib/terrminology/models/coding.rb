module Terrminology
  class Coding
    include Virtus.model
    attribute :system,    String  #0..1
    attribute :version,   String  #0..1
    attribute :code,      String  #0..1
    attribute :display,   String  #0..1
    attribute :primary,   Boolean #0..1
    attribute :value_set, String

    def ==(other)
      self.system  == other.system &&
      self.version == other.version &&
      self.code    == other.code
    end

    def initialize(attrs)
      attributes.keys.each do |attr_name|
        self.send("#{attr_name}=", attrs[attr_name])
      end
    end
  end
end
