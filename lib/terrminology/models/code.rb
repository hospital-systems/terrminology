module Terrminology
  class Code < BaseModel
    attribute :code_id,    String
    attribute :include_id, String
    attribute :value,      String #1..1
  end
end