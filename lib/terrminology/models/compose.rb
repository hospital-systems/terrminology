module Terrminology
  class Compose < BaseModel
    attribute :compose_id,   String
    attribute :value_set_id, String
    attribute :import,       String #0..*
  end
end
