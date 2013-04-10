module Build
  module Task
    class Base
      attr_reader :build
      
      def initialize(_build = nil)
        @build = _build
      end
      def run
      end
    end
  end
end
