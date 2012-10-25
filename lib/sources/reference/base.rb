module Sources
  module Reference
    class Base
      attr_reader :runner
    
      def initialize(runner, parts)
        @runner = runner

        @problematic = false
        if parts.first == false
          parts.shift
          @problematic = true
        end
        @parts = parts
      end

      def enumerate(arr)
        if arr.size > 1
          arr[0..-2].join(', ') + " sowie " + arr[-1]
        else
          arr[0]
        end
      end

      def sources(add_page_ref = true)
        []
      end

      def to_str
        without_page_ref
      end
      alias to_s to_str

      def track
        @runner.build.track
      end

      def with_page_ref
        sentence = enumerate(sources)
        prefix = "Vgl. "
        suffix = sentence =~ /\.$/ ? "" : "."
        str = prefix + sentence + suffix
        @to_s = @problematic ? "#{str} [korrekt?]" : str
      end

      def without_page_ref
        sources(false).join('')
      end
    end
  end
end
