require 'yaml'
require 'sequel'
require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup'
require 'terrminology'

cfg = YAML.load(File.read(File.dirname(__FILE__) + '/spec/connection.yml'))
db = cfg.delete('db')
DB = Sequel.postgres(db, cfg)
Terrminology::Migrator.migrate(DB)
