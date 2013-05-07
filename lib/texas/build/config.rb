module Texas
  module Build
    class Config
      def initialize(hash)
        @hash = hash.stringify_keys
      end

      def [](key)
        @hash[key.to_s]
      end

      def document
        @document ||= OpenStruct.new self[:document]
      end

      def merge!(key)
        @document = nil
        merge_hash = @hash[key.to_s]
        if merge_hash
          @hash.deep_merge! merge_hash.stringify_keys
          self
        else
          raise "Trying to merge config with none existing key #{key.inspect}"
        end
      end

      def method_missing(m, *args, &block)
        self[m] || super
      end

      def script(key)
        hash = self[:script] || {}
        hash[key.to_s]
      end

      def self.create(hash, merge_key = nil)
        config = self.new hash
        config.merge! merge_key if merge_key
        config
      end
    end
  end
end
