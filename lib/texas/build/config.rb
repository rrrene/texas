module Texas
  module Build
    # This class holds the config information for a build.
    #
    class Config
      def initialize(hash)
        @hash = hash.stringify_keys
      end

      def [](key)
        @hash[key.to_s]
      end

      # Returns an object for the +document+ config key.
      #
      # Example:
      #   # .texasrc
      #
      #   document:
      #     title: "My Document"
      #
      #   config = Config.new YAML.load_file(".texasrc") 
      #   # => #<Texas::Build::Config ...>
      #
      #   config.document.title
      #   # => "My Document"
      #
      def document
        @document ||= OpenStruct.new self[:document]
      end

      # Returns an object for the +document+ config key.
      #
      # Example:
      #   # .texasrc
      #
      #   document:
      #     title: "My Document (DRAFT!)"
      #   final:
      #     document:
      #       title: "My Document"
      #
      #   config = Config.new YAML.load_file(".texasrc") 
      #   # => #<Texas::Build::Config ...>
      #
      #   config.document.title
      #   # => "My Document (DRAFT!)"
      #
      #   config.merge! :final
      #   # => #<Texas::Build::Config ...>
      #
      #   config.document.title
      #   # => "My Document"      
      #
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

      # Returns an element from the +script+ config key
      #
      # Example:
      #   # .texasrc
      #
      #   script:
      #     before: "touch some_file"
      #   document:
      #     title: "My Document"
      #
      #   config = Config.new YAML.load_file(".texasrc") 
      #   # => #<Texas::Build::Config ...>
      #
      #   config.script(:before)
      #   # => "touch some_file"
      #
      #   config.script(:after)
      #   # => nil
      #
      def script(key)
        hash = self[:script] || {}
        hash[key.to_s]
      end

      # Returns a Config object.
      #
      # Example:
      #   # .texasrc
      #
      #   document:
      #     title: "My Document (DRAFT!)"
      #   final:
      #     document:
      #       title: "My Document"
      #
      #   config = Config.create YAML.load_file(".texasrc"), :final
      #   # => #<Texas::Build::Config ...>
      #
      #   config.document.title
      #   # => "My Document"   
      #
      def self.create(hash, merge_key = nil)
        config = self.new hash
        config.merge! merge_key if merge_key
        config
      end
    end
  end
end
