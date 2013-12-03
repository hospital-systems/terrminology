require 'json'

module Terrminology
  class ValueSetLoader
    VALUE_SETS_DIR = '../../../data/value_sets'

    def load(filename)
      sys = Terrminology.api(DB)
      sys.create_value_set(
          JSON.parse(
              File.read(File.join(File.dirname(__FILE__), VALUE_SETS_DIR, filename))
          )
      )
    end
  end
end
