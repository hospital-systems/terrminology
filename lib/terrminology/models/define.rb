module Terrminology
  class Define < BaseModel
    attribute :define_id,       String
    attribute :value_set_id,    String
    attribute :system,          String  #1..1 #uri, но пока просто String
    attribute :version,         String  #0..1
    attribute :case_sensitive,  Boolean # 0..1
  end
end
