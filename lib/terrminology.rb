require 'terrminology/version'
require 'virtus'

module Terrminology
  autoload :Utils,                   'terrminology/utils'
  autoload :Migrator,                'terrminology/migrator'
  autoload :Facade,                  'terrminology/facade'

  autoload :BaseModel,               'terrminology/models/base_model'
  autoload :ValueSet,                'terrminology/models/value_set'
  autoload :Define,                  'terrminology/models/define'
  autoload :Concept,                 'terrminology/models/concept'
  autoload :ConceptMap,              'terrminology/models/concept_map'
  autoload :SourceConcept,           'terrminology/models/source_concept'
  autoload :Map,                     'terrminology/models/map'
  autoload :Compose,                 'terrminology/models/compose'
  autoload :Include,                 'terrminology/models/include'
  autoload :Code,                    'terrminology/models/code'
  autoload :Filter,                  'terrminology/models/filter'

  autoload :BaseRepository,          'terrminology/repositories/base_repository'
  autoload :ValueSetRepository,      'terrminology/repositories/value_set_repository'
  autoload :DefineRepository,        'terrminology/repositories/define_repository'
  autoload :ConceptRepository,       'terrminology/repositories/concept_repository'
  autoload :ConceptMapRepository,    'terrminology/repositories/concept_map_repository'
  autoload :SourceConceptRepository, 'terrminology/repositories/source_concept_repository'
  autoload :MapRepository,           'terrminology/repositories/map_repository'
  autoload :ComposeRepository,       'terrminology/repositories/compose_repository'
  autoload :IncludeRepository,       'terrminology/repositories/include_repository'
  autoload :CodeRepository,          'terrminology/repositories/code_repository'
  autoload :FilterRepository,        'terrminology/repositories/filter_repository'


  autoload :ValueSetStatus,          'terrminology/custom_coercions/value_set_status'
  autoload :FilterOperator,          'terrminology/custom_coercions/filter_operator'
  autoload :ConceptMapEquivalence,   'terrminology/custom_coercions/concept_map_equivalence'

  autoload :ValueSetLoader,          'terrminology/loaders/value_set_loader'
  autoload :MappingLoader,           'terrminology/loaders/mapping_loader'

  autoload :Coding,                  'terrminology/models/coding'

  def self.api(*args)
    Facade.new(*args)
  end
end
