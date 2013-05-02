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
        @hash.deep_merge! @hash[key.to_s].stringify_keys
        self
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
