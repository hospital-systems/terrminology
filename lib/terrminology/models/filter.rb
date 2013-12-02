module Terrminology
  class Filter < BaseModel
    attribute :filter_id,  String
    attribute :include_id, String
    attribute :property,   String #1..1
    attribute :op,         FilterOperator #1..1
    attribute :value,      String #1..1
  end
end
