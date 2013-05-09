module Texas
  module Build
    # This class looks for a given filename in the current and all parent directories.
    #
    #   # Given the following directory structure:
    #
    #   ~/
    #     projects/
    #       some_texas_project/
    #         .texasrc
    #     .texasrc
    #
    # In the above case, it would find and load 
    # ~/.texasrc and ~/projects/some_texas_project/.texasrc
    # with the latter one overriding settings in the former one.
    #
    class ConfigLoader
      def initialize(start_dir, filename)
        @start_dir = start_dir
        @filename = filename
      end

      # Returns all found files with the given filename in the current and all parent directories.
      #
      # Example:
      #   # Given the following directory structure:
      #
      #   ~/
      #     projects/
      #       some_texas_project/
      #         .texasrc
      #     .texasrc
      #
      #   all_config_files
      #   # => ["~/.texasrc", "~/projects/some_texas_project/.texasrc"]
      #
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

      # Returns a hash of all the found config files.
      #
      # Example:
      #   # Given the following directory structure:
      #
      #   ~/
      #     projects/
      #       some_texas_project/
      #         .texasrc
      #     .texasrc
      #
      #   # ~/.texasrc
      #   
      #   document:
      #     author: "John Doe"
      #     some_value: 42
      #
      #   # ~/projects/some_texas_project/.texasrc
      #   
      #   document:
      #     title: "My Document"
      #     some_value: 123
      #
      #   to_hash
      #   # => {:document => {
      #          :author => "John Doe", 
      #          :title => "My Document", 
      #          :some_value => 123}}
      #          
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
