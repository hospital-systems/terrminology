require 'sequel'
module Terrminology
  class Migrator
    class << self
      def migrate(db)
        Sequel.extension :pg_array_ops, :pg_row_ops, :migration
        db.extension(:pg_array, :pg_row, :pg_hstore)
        Sequel::Migrator.run(db, File.dirname(__FILE__) + '/../../db/migrations', use_transactions: true, table: :terrminology_schema_migrations)
      end
    end
  end
end
