module Build
  module Task
    class AddClearlyMissingAbbrevs < Base

      def config
        build.config
      end
      
      def track
        build.track
      end

      def find(*use_classes)
        compiled_files = Dir[File.join(build.__path__, "**/*.tex")]
        found = []
        use_classes.flatten.each do |klass|
          found << klass.new(compiled_files).to_a
        end
        found.flatten.uniq.sort
      end

      def found_abbrevs
        find Find::Abbreviations, Find::Acronyms
      end
        
      def tracked_abbrevs
        track.abbreviations.map(&:first).uniq
      end

      def run
        missing_abbrevs = found_abbrevs - tracked_abbrevs
        known_abbrevs = missing_abbrevs & (config["abbrevs"] || {}).keys
        false_abbrevs = [ config["false_abbrevs"] ].flatten.compact
        known_abbrevs.each do |key|
          track.abbreviation(key, config["abbrevs"][key])
        end

        left_unknown_abbrevs = missing_abbrevs - known_abbrevs - false_abbrevs
        left_unknown_abbrevs.select! { |a| !known_abbrevs.map(&:downcase).include?(a.downcase) }
        # TODO: store in build

        verbose { "Adding known abbrevs: " + known_abbrevs.inspect } unless known_abbrevs.empty?
      end
    end
  end
end
