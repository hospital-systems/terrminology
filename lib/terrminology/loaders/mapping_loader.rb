module Terrminology
  class MappingLoader
    MAPPINGS_DIR = '../../../data/mappings'

    def initialize(facade)
      @facade = facade
    end

    def load(filename)
      @facade.create_concept_map(
          JSON.parse(
              File.read(File.join(File.dirname(__FILE__), MAPPINGS_DIR, filename))
          )
      )
    end
  end
end
