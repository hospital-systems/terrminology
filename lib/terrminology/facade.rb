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
      @db.transaction(:savepoint => true) do
        value_set_attributes = u.normalize_attributes(attrs)

        value_set_attributes.delete('resource_type')
        value_set_attributes.delete('text')
        value_set_attributes.delete('telecom')
        define  = value_set_attributes.delete('define')

        compose = value_set_attributes.delete('compose')

        if define && compose
          raise ArgumentError, "Value set #{value_set_attributes['identifier']} contains both compose and define"
        elsif define
          create_defined_value_set(value_set_attributes, define)
        elsif compose
          create_composed_value_set(value_set_attributes, compose)
        end
      end
    end

    def create_defined_value_set(value_set_attributes, define)
      value_set_repository.create(value_set_attributes).tap do |vs|
        define['value_set_id'] = vs.identity
        concepts = define.delete('concept')
        df = define_repository.create(define)

        concepts.map do |concept|
          create_concept(concept.merge(define_id: df.identity))
        end
      end
    end

    def create_composed_value_set(value_set_attributes, compose)
      value_set_repository.create(value_set_attributes).tap do |vs|
        compose['value_set_id'] = vs.identity
        includes = compose.delete('include')
        compose  = compose_repository.create(compose)

        includes.map do |include|
          raise ArgumentError, "Required value set #{include['system']} missing" unless find_required_value_set(include)
          include['compose_id'] = compose.identity
          filters = include.delete('filter')
          codes   = include.delete('code')

          include = include_repository.create(include)

          filters.map do |filter|
            filter['include_id'] = include.identity
            filter_repostory.create(filter)
          end if filters

          codes.map do |code|
            code_repository.create(value: code, include_id: include.identity)
          end
        end
      end
    end

    def find_required_value_set(include_attributes)
      vs = find_value_set(include_attributes['system'])
      if vs.nil?
        split_system_uri = include_attributes['system'].split('/')
        vs = find_value_set([*split_system_uri[0..-2], 'vs', split_system_uri[-1]].join('/'))
      end
      vs
    end

    private :create_defined_value_set, :create_composed_value_set, :find_required_value_set

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
      child_concepts = concept_attributes.delete('concept')
      concept_repository.create(concept_attributes).tap do |concept|
        child_concepts.map do |child_concept|
          create_concept(
              child_concept.merge(
                  define_id: concept.define_id,
                  path:      [concept.path, concept.code].compact.join('/'),
                  parent_id: concept.identity
              )
          )
        end if child_concepts
      end
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

    def load_value_set(filename)
      ValueSetLoader.new.load(filename)
    end

    def compose_repository
      ComposeRepository.new(db)
    end

    def include_repository
      IncludeRepository.new(db)
    end

    def filter_repository
      FilterRepository.new(db)
    end

    def code_repository
      CodeRepository.new(db)
    end
  end
end
