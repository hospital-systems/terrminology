require 'fhir_value_sets/version'
require 'virtus'

module FHIRValueSets
  autoload :Migrator, 'fhir_value_sets/migrator'
  autoload :Facade, 'fhir_value_sets/facade'

  autoload :BaseModel, 'fhir_value_sets/models/base_model'
  autoload :ValueSet, 'fhir_value_sets/models/value_set'
  autoload :Define,   'fhir_value_sets/models/define'
  autoload :Concept,  'fhir_value_sets/models/concept'

  autoload :BaseRepository,     'fhir_value_sets/repositories/base_repository'
  autoload :ValueSetRepository, 'fhir_value_sets/repositories/value_set_repository'
  autoload :DefineRepository,   'fhir_value_sets/repositories/define_repository'
  autoload :ConceptRepository,  'fhir_value_sets/repositories/concept_repository'

  autoload :ValueSetStatus, 'fhir_value_sets/custom_coercions/value_set_status'
end
