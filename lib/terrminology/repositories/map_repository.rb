module Terrminology
  class MapRepository < BaseRepository
    def search(id, maps_filter)
      raise 'I need id'  unless id

      rel = relation.select_all(table_name)
      .join(:terrminology__source_concepts, [:source_concept_id])

      rel = rel.filter(source_concepts__source_concept_id: id)

      if maps_filter
        rel = rel.where(maps_filter)
      end

      rel.map{|e| wrap(e)}
    end
  end
end
