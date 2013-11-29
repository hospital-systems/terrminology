require 'terrminology/version'
require 'virtus'

module Terrminology
  autoload :Utils, 'terrminology/utils'
  autoload :Migrator, 'terrminology/migrator'
  autoload :Facade, 'terrminology/facade'

  autoload :BaseModel, 'terrminology/models/base_model'
  autoload :ValueSet, 'terrminology/models/value_set'
  autoload :Define,   'terrminology/models/define'
  autoload :Concept,  'terrminology/models/concept'

  autoload :BaseRepository,     'terrminology/repositories/base_repository'
  autoload :ValueSetRepository, 'terrminology/repositories/value_set_repository'
  autoload :DefineRepository,   'terrminology/repositories/define_repository'
  autoload :ConceptRepository,  'terrminology/repositories/concept_repository'

  autoload :ValueSetStatus, 'terrminology/custom_coercions/value_set_status'
end
