module Terrminology
  class MappingLoader
    MAPPINGS_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../../../data/mappings'))

    def initialize(facade)
      @facade = facade
    end

    def load(filename)
      @facade.create_concept_map(
          JSON.parse(
              File.read(File.join(MAPPINGS_DIR, filename))
          )
      )
    end

    def load_all
      loaded = nil
      Dir.chdir(MAPPINGS_DIR) do
        filenames = Dir['*json']
        filenames.each do |filename|
          load(filename)
        end
        loaded = filenames.size
      end
      {loaded: loaded}
    end
  end
end
