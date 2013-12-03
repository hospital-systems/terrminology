require 'json'

module Terrminology
  class ValueSetLoader
    def load(filename)
      sys = Terrminology.api(DB)
      sys.create_value_set(
          JSON.parse(
              File.read(File.join(File.dirname(__FILE__), '../../../data/value_sets', filename))
          )
      )
    end
  end
end
