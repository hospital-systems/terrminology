require 'terrminology'
require 'sequel'
require 'yaml'

Sequel.extension :pg_array_ops, :pg_row_ops
DB = Sequel.connect(ENV['SEQUEL'] || 'postgres:///terrminology')
DB.extension(:pg_array, :pg_row, :pg_hstore)
