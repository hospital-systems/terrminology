module Terrminology
  class Concept < BaseModel
    attribute :concept_id, String
    attribute :define_id,  String
    attribute :code,       String  #1..1
    attribute :abstract,   Boolean #0..1
    attribute :display,    String  #0..1
    attribute :definition, String  #0..1
    attribute :parent_id,  String
    attribute :path,       String
  end
end
