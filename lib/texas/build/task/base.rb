module Texas
  module Build
    module Task
      class Base
        include Texas::CLI::OutputHelper
        attr_reader :build

        def initialize(_build = nil)
          @build = _build
        end

        def run
        end
      end
    end
  end
end
