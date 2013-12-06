module Terrminology
  class Compose < BaseModel
    attribute :compose_id,   String
    attribute :value_set_id, String
    # TODO: process multiple imports (enumeration in postgres? separate table?)
    attribute :import,       String #0..*
  end
end
