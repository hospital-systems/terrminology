module Terrminology
  module Utils
    def underscore(name)
      name.gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end

    def is_uuid?(str)
      str =~ /^[0-9a-z]{8}(-[0-9a-z]{4}){2}/
    end

    def convert_code_system_id_to_value_set_id(system)
      split_system_uri = system.split('/')
      [*split_system_uri[0..-2], 'vs', split_system_uri[-1]].join('/')
    end

    def normalize_attributes(attrs)
      if attrs.is_a?(Hash)
        res = {}
        attrs.each do |k, v|
          res[underscore(k.to_s)] = normalize_attributes(v)
        end
        res
      elsif attrs.is_a?(Array)
        attrs.map do |v|
          normalize_attributes(v)
        end
      else
        attrs
      end
    end
    extend self
  end
end
