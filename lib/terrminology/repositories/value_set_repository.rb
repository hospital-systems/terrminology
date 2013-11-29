module Terrminology
  class ValueSetRepository < BaseRepository
    def find(id_or_identifier)
      rel = if u.is_uuid?(id_or_identifier)
              relation.filter(value_sets__value_set_id: id_or_identifier)
            else
              relation.filter(value_sets__identifier: id_or_identifier)
            end
      wrap(rel.first)
    end
  end
end
