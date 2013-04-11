module Texas
  module Build
    class Tracker
      [
        :abbreviations, :citations, :figures, :figure_references, :labels, :label_references, :miscitations, :tables
      ].each do |method_name|
        define_method :"__#{method_name}__" do
          instance_variable_get("@#{method_name}") || []
        end
        define_method method_name do
          collection = instance_variable_get("@#{method_name}") || []
          collection.map do |arr| 
            values = arr.last
            values.size == 1 ? values[0] : values
          end
        end
      end

      def initialize(_build)
        @build = _build
      end

      def abbreviation(short, long)
        track :abbreviation, [short, long]
      end

      def citation(sym, pages)
        track :citation, [sym.to_s, pages]
      end

      def figure(sym)
        track :figure, [sym.to_s]
      end

      def figure_reference(sym)
        track :figure_reference, [sym.to_s]
      end

      def label(sym)
        track :label, [sym.to_s]
      end

      def label_reference(sym)
        track :label_reference, [sym.to_s]
      end

      def miscitation(sym)
        track :miscitation, [sym.to_s]
      end

      def table_reference(sym)
        track :table_reference, [sym.to_s]
      end

      private

      def track(key, args)
        filename = @build.current_template && @build.current_template.filename
        collection_name = "#{key}s" # pluralize for dummies
        collection = instance_variable_get("@#{collection_name}")
        collection = [] if collection.nil?
        collection << [filename, args]
        instance_variable_set("@#{collection_name}", collection)
      end

    end
  end
end
