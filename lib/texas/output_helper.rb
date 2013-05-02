module Texas
  module OutputHelper
    def trace(*args)
      puts *args
    end

    def verbose(&block)
      if Texas.verbose
        value = block.()
        if value.is_a?(String)
          trace value
        else
          pp value
        end
      end
    end

    def warning(&block)
      if Texas.warnings
        value = block.()
        if value.is_a?(String)
          trace "[WARNING]".yellow + " #{value}"
        else
          pp value
        end
      end
    end
  end
end
