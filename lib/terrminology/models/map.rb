module Terrminology
  class Map < BaseModel
    attribute :map_id,            String
    attribute :source_concept_id, String
    attribute :system,            String                #1..1
    attribute :code,              String                #0..1
    attribute :equivalence,       ConceptMapEquivalence #1..1
    attribute :comments,          String                #0..1
  end
end
