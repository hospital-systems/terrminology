module FHIRValueSets
  class BaseRepository
    attr_reader :db

    def initialize(db)
      @db = db
    end

    def table_name
      dasherize(entity_name) + 's'
    end

    def entity_name
      self.class.name.split('::').last.gsub(/Repository$/,'')
    end

    def entity
      @entity ||= FHIRValueSets.const_get(entity_name)
    end

    def relation
      get_relation(table_name)
    end

    def get_relation(table_name)
      @db[:"fhir_value_sets__#{table_name}"]
    end

    def all
      relation.all.map{|r| wrap(r)}
    end

    def wrap(row)
      entity.new(row)
    end

    def create(atts)
      identity = relation.insert(atts)
      atts["#{dasherize(entity_name)}_id"] = identity
      entity.new(atts)
    end

    def destroy_all
      relation.delete
    end

    def dasherize(name)
      name.gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
  end
end
