module Terrminology
  class ConceptRepository < BaseRepository
    def u
      Utils
    end

    def search(id_or_identifier)
      raise 'I need id_or_identifier of valueset'  unless id_or_identifier

      rel = relation
      .join(:terrminology__defines, [:define_id])
      .join(:terrminology__value_sets, [:value_set_id])

      if u.is_uuid?(id_or_identifier)
        rel = rel.filter(value_sets__value_set_id: id_or_identifier)
      else
        rel = rel.filter(value_sets__identifier: id_or_identifier)
      end
      rel.map{|e| wrap(e)}
    end
  end
end

