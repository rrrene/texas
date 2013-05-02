module Texas
  module OutputHelper
    def trace(*args)
      puts *args
    end

    def verbose(&block)
      if Texas.verbose
        trace block.()
      end
    end

    def warning(&block)
      if Texas.warnings
        trace "[WARNING]".yellow + " #{block.()}"
      end
    end
  end
end
