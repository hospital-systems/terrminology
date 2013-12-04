module Terrminology
  class ConceptMapRepository < BaseRepository
    def find(source_vs, target_vs)
      search(source: source_vs, target: target_vs).first
    end

    def search(concept_maps_filter)
      rel = relation.where(concept_maps_filter)
      rel.map{|e| wrap(e)}
    end
  end
end
