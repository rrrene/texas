module Texas
  module Build
    class ConfigLoader
      def initialize(start_dir, filename)
        @start_dir = start_dir
        @filename = filename
      end

      def all_config_files
        found_files = []
        each_parent_dir(@start_dir) do |dir|
          filename = File.join(dir, @filename)
          found_files.unshift filename if File.exist?(filename)
        end
        found_files
      end

      def each_parent_dir(dir)
        old_length = nil
        while dir != '.' && dir.length != old_length
          yield dir
          old_length = dir.length
          dir = File.dirname(dir)
        end
      end

      def to_hash
        hash = {}
        all_config_files.each do |filename|
          hash.deep_merge! YAML.load_file(filename) 
        end
        hash
      end
    end
  end
end
