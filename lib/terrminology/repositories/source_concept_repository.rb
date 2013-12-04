module Terrminology
  class SourceConceptRepository < BaseRepository
    def search(id_or_identifier, source_concepts_filter)
      raise 'I need id_or_identifier of value_set'  unless id_or_identifier

      rel = relation
      .join(:terrminology__concept_maps, [:concept_map_id])

      if u.is_uuid?(id_or_identifier)
        rel = rel.filter(concept_maps__concept_map_id: id_or_identifier)
      else
        rel = rel.filter(concept_maps__identifier: id_or_identifier)
      end

      if source_concepts_filter
        rel = rel.where(source_concepts_filter)
      end

      rel.map{|e| wrap(e)}
    end
  end
end
