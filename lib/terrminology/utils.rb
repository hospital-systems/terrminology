module Terrminology
  module Utils
    def underscore(name)
      name.gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end

    def is_uuid?(str)
      str =~ /^[0-9a-z]{8}(-[0-9a-z]{4}){2}/
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
