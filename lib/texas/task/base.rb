module Texas
  module Task
    class Base
      include Texas::OutputHelper
      attr_accessor :options

      def initialize(_options, _build = nil)
        self.options = _options
        @build = _build if _build
      end

      def build(klass = Build::Dry)
        @build ||= begin
          b = klass.new(options)
          b.run
          b
        end
      end

      def run
      end
    end
  end
end
