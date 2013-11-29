module Terrminology
  class Facade
    def u
      Utils
    end

    attr_reader :db

    def initialize(db)
      @db = db
    end

    def value_set_repository
      ValueSetRepository.new(db)
    end

    private :value_set_repository

    def value_sets
      value_set_repository.all
    end

    def create_value_set(attrs)
      value_set_attributes = u.normalize_attributes(attrs)

      value_set_attributes.delete('resource_type')
      value_set_attributes.delete('text')
      value_set_attributes.delete('telecom')
      define = value_set_attributes.delete('define')

      value_set_repository.create(value_set_attributes).tap do |vs|
        define['value_set_id'] = vs.identity
        concepts = define.delete('concept')
        df = define_repository.create(define)

        concepts = concepts.map do |concept|
          concept_repository.create(concept.merge(define_id: df.identity))
        end
      end
    end

    def find_value_set(id_or_identifier)
      value_set_repository.find(id_or_identifier)
    end

    def clear_value_sets!
      value_set_repository.destroy_all
    end

    def define_repository
      DefineRepository.new(db)
    end

    private :define_repository

    def defines
      define_repository.all
    end

    def create_define(define_attributes)
      define_repository.create(define_attributes)
    end

    def clear_defines!
      define_repository.destroy_all
    end

    def concept_repository
      ConceptRepository.new(db)
    end

    private :concept_repository

    def concepts(id_or_identifier, concepts_filter = nil)
      concept_repository.search(id_or_identifier, concepts_filter)
    end

    def create_concept(concept_attributes)
      concept_repository.create(concept_attributes)
    end

    def clear_concepts!
      concept_repository.destroy_all
    end

    def add_concept(id_or_identifier, concept_attributes)
      #TODO: accept an array of hashes
      value_set = find_value_set(id_or_identifier)
      define    = find_define(value_set.identity)
      create_concept(concept_attributes.merge(define_id: define.identity))
    end

    def remove_concept(concept_id)
      concept_repository.destroy(concept_id)
    end

    def find_define(value_set_id)
      define_repository.find(value_set_id)
    end

    private :find_define
  end
end
