module TypesLib
  class Enum
    def initialize(attrs)
      @hash_attrs = extract_hash_attrs_from(attrs)
      create_getters_from_hash(@hash_attrs)
    end

    def [](attr)
      unless @hash_attrs.has_key? attr
        raise ArgumentError, "'#{attr}' attribute does not exist."
      end

      @hash_attrs[attr]
    end

  private
    def extract_hash_attrs_from(attrs)
      if attrs.is_a? Hash
        return attrs.clone

      elsif attrs.is_a? Enumerable
        hash = {}
        attrs.each_with_index do |val, i|
          hash[val] = i
        end
        return hash

      end
    end

    def create_getters_from_hash(hash_attrs)
      hash_attrs.each_pair do |attr, val|
        self.instance_eval do
          define_singleton_method attr.to_sym do
            val
          end
        end
      end
    end

  end
end
