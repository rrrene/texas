module Texas
  module Task
    class Base
      attr_accessor :options

      def initialize(_options, _build = nil)
        self.options = _options
        @build = _build if _build
      end

      def build(klass = Build::Dry)
        @build ||= klass.run(options)
      end

      def track
        build.track
      end

      def run
      end
    end
  end
end
