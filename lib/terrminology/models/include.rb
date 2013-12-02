module Terrminology
  class Include < BaseModel
    attribute :include_id, String
    attribute :compose_id, String
    attribute :system,     String #1..1
    attribute :version,    String #0..1
  end
end
