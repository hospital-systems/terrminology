module Terrminology
  class BaseRepository
    def u
      Utils
    end

    attr_reader :db

    def initialize(db)
      @db = db
    end

    def table_name
      u.underscore(entity_name) + 's'
    end

    def entity_name
      self.class.name.split('::').last.gsub(/Repository$/,'')
    end

    def entity
      @entity ||= Terrminology.const_get(entity_name)
    end

    def relation
      get_relation(table_name)
    end

    def get_relation(table_name)
      @db[:"terrminology__#{table_name}"]
    end

    def all
      relation.all.map{|r| wrap(r)}
    end

    def wrap(row)
      entity.new(row)
    end

    def create(atts)
      identity = relation.insert(atts)
      atts["#{u.underscore(entity_name)}_id"] = identity
      entity.new(atts)
    end

    def destroy_all
      relation.delete
    end
  end
end
