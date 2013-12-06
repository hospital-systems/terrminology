module Terrminology
  class SourceConcept < BaseModel
    attribute :source_concept_id, String
    attribute :concept_map_id,    String
    attribute :name,              String #0..1
    attribute :system,            String #0..1
    attribute :code,              String #0..1
  end
end
