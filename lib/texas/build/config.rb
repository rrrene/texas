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

      def self.create(filename, merge_key = nil)
        hash = File.exist?(filename) ? YAML.load_file(filename) : {}
        config = self.new hash
        config.merge! merge_key if merge_key
        config
      end
    end
  end
end
