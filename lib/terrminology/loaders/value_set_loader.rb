require 'json'
require 'tsort'

module Terrminology
  module ValueSetLoader
    extend self
    VALUE_SETS_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../../../data/value_sets'))

    def load(filename)
      sys = Terrminology.api(DB)
      sys.create_value_set(get_json(filename))
    end

    def load_all_value_sets
      sys = Terrminology.api(DB)

      value_sets = json_files.reduce(ValueSetFiles.new) do |value_sets, filename|
        value_set = get_json(filename)
        value_sets[value_set['identifier']] = value_set
        value_sets
      end
      value_sets.tsort.each { |identifier| sys.create_value_set(value_sets[identifier]) }
    end

    private
    def json_files
      Dir.chdir(VALUE_SETS_DIR) do
        Dir['*json']
      end
    end

    def get_json(filename)
      JSON.parse(File.read(File.join(VALUE_SETS_DIR, filename)))
    end

    class ValueSetFiles < Hash
      include TSort
      alias tsort_each_node each_key
      def tsort_each_child(node, &block)
        requirements(fetch(node)).each(&block)
      end

      def requirements(attrs)
        if attrs['compose']
          attrs['compose']['include'].map { |inc| Utils.convert_code_system_id_to_value_set_id inc['system'] }
        else
          []
        end
      end
    end
  end
end
