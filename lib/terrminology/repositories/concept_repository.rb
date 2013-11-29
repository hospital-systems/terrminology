module Terrminology
  class ConceptRepository < BaseRepository
    def u
      Utils
    end

    def search(id_or_identifier, concepts_filter)
      raise 'I need id_or_identifier of value_set'  unless id_or_identifier

      rel = relation
      .join(:terrminology__defines, [:define_id])
      .join(:terrminology__value_sets, [:value_set_id])

      if u.is_uuid?(id_or_identifier)
        rel = rel.filter(value_sets__value_set_id: id_or_identifier)
      else
        rel = rel.filter(value_sets__identifier: id_or_identifier)
      end

      if concepts_filter
        rel = rel.where(concepts_filter)
      end

      rel.map{|e| wrap(e)}
    end

    def find(concept_id)
      search(value_set_id_or_identifier, concept_id: concept_id_or_code).first
    end

    def destroy(concept_id)
      relation.where(concept_id: concept_id).delete
    end
  end
end

