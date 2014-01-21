module StandardLib
  class HashFlatter
    attr_reader :hash

    def initialize(hash)
      @hash = hash.clone
    end

    def flatten(prefix, &block)
      to_flatten = @hash.find_all do |key,_|
        key =~ /\A#{prefix}\(\d+i\)$/
      end

      if !to_flatten.empty?
        value = yield to_flatten.sort_by{|key, _| key}.map{|(key, value)| value}

        to_flatten.each{|key, _| @hash.delete(key)}
        @hash[prefix] = value
      end
    end
  end
end
