def verbose(&block)
  if Texas.verbose
    value = block.()
    if value.is_a?(String)
      puts value
    else
      pp value
    end
  end
end

def warning(&block)
  if Texas.warnings
    value = block.()
    if value.is_a?(String)
      puts "[WARNING]".yellow + " #{value}"
    else
      pp value
    end
  end
end

module Texas
  class Runner
    attr_reader :task_instance

    def initialize(force_options = nil)
      @options = if force_options.nil?
        Texas::OptionParser.parse(ARGV)
      else
        opts = Texas::OptionParser.parse([])
        force_options.each { |k, v| opts.send("#{k}=", v) }
        opts
      end
      Texas.verbose = @options.verbose
      Texas.warnings = @options.warnings
      @task_instance = task_class.new(@options)
      @task_instance.run
    end

    def task_class
      map = {
        :build      => Build::Final,
        :dry        => Build::Dry,
      }
      map[@options.task] || fallback_task_class
    end

    def fallback_task_class 
      class_name = @options.task.to_s.capitalize
      eval("Task::#{class_name}")
    end
  end
end
