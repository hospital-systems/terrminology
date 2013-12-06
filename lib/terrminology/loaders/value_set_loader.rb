require 'json'
require 'tsort'
require 'active_support/core_ext/hash'

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
        parsed_json = get_json(filename)
        if parsed_json['resourceType'] && parsed_json['resourceType'] == 'ValueSet'
          parsed_value_sets = [parsed_json]
        elsif parsed_json['feed'] && parsed_json['feed']['entry']
          parsed_value_sets = parsed_json['feed']['entry'].map{|entry| entry['content']}
        else
          parsed_value_sets = []
        end

        parsed_value_sets.map{ |value_set| value_sets[value_set['identifier']] = value_set}

        value_sets
      end

      total  = value_sets.size
      value_sets.remove_value_sets_with_unsatisfied_dependencies!
      loaded = value_sets.size

      value_sets.tsort.each do |identifier|
        sys.create_value_set(value_sets[identifier])
      end

      {:total => total, :loaded => loaded}
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
        reqs = []
        if attrs['compose']
          reqs << attrs['compose']['import'] if attrs['compose']['import']
          reqs += attrs['compose']['include'].map { |inc| Utils.convert_code_system_id_to_value_set_id inc['system'] } if attrs['compose']['include']
        end
        reqs
      end

      def remove_value_sets_with_unsatisfied_dependencies!
        self.delete_if{ |_, value| requirements(value).any?{ |required_identifier| self[required_identifier].nil? } }
      end
    end
  end
end
