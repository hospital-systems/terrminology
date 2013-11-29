require 'yaml'
require 'sequel'
require 'rubygems'
require 'bundler/setup'
require 'fhir_value_sets'

cfg = YAML.load(File.read(File.dirname(__FILE__) + '/spec/connection.yml'))
db = cfg.delete('db')
DB = Sequel.postgres(db, cfg)
FHIRValueSets::Migrator.migrate(DB)
