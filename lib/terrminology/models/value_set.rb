module Terrminology
  class ValueSet < BaseModel
    attribute :value_set_id, String
    #TODO: should be required
    attribute :identifier,   String         #0..1
    attribute :version,      String         #0..1
    attribute :name,         String         #1..1
    attribute :publisher,    String         #0..1
    #TODO: find a proper way of storing telecom data
    #attribute :telecom,      Contact        #0..*
    attribute :description,  String         #1..1
    attribute :copyright,    String         #0..1
    attribute :status,       ValueSetStatus #1..1 #создать класс Enum %w(draft active retired) на уровне и Ruby, и PostgreSQL
    attribute :experimental, Boolean        #0..1
    attribute :extensible,   Boolean        #0..1
    attribute :date,         DateTime       #0..1
  end
end
