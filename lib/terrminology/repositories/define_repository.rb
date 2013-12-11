module Terrminology
  class DefineRepository < BaseRepository
    def find(define_id)
      wrap(relation.where(define_id: define_id).first)
    end

    def find_by_value_set_id(value_set_id)
      wrap(relation.where(value_set_id: value_set_id).first)
    end
  end
end
