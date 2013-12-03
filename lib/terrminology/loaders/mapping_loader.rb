require 'json'

module Terrminology
  class MappingLoader
    MAPPINGS_DIR = '../../../data/mappings'

    def load(filename)
      sys = Terrminology.api(DB)
      sys.create_concept_map(
          JSON.parse(
              File.read(File.join(File.dirname(__FILE__), MAPPINGS_DIR, filename))
          )
      )
    end
  end
end
