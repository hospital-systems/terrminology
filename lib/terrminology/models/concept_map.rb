module Terminology
  class ConceptMap
    attribute :concept_map_id, String
    attribute :identifier,     String         #0..1
    attribute :version,        String         #0..1
    attribute :name,           String         #1..1
    attribute :publisher,      String         #0..1
    #TODO: find a proper way of storing telecom data
    #attribute :telecom,       Contact        #0..*
    attribute :description,    String         #1..1
    attribute :copyright,      String         #0..1
    attribute :status,         ValueSetStatus #1..1
    attribute :experimental,   Boolean        #0..1
    attribute :date,           DateTime       #0..1
    attribute :source,         String         #1..1
    attribute :target,         String         #1..1
  end
end
