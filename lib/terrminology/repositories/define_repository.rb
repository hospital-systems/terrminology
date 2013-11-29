module Terrminology
  class DefineRepository < BaseRepository
    def find(value_set_id)
      wrap(relation.where(value_set_id: value_set_id).first)
    end
  end
end
