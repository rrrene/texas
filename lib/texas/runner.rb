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
        Texas::OptionParser.new(ARGV).parse
      else
        opts = Texas::OptionParser.new([]).parse
        force_options.each { |k, v| opts.send("#{k}=", v) }
        opts
      end
      extend_string_class
      Texas.verbose = @options.verbose
      Texas.warnings = @options.warnings
      load_local_libs if @options.load_local_libs
      @task_instance = task_class.new(@options)
      @task_instance.run
    end
    
    def extend_string_class
      mod = @options.colors ? Term::ANSIColor : Term::NoColor
      String.send :include, mod
    end

    def load_local_libs
      init_file = File.join(@options.work_dir, "lib", "init.rb")
      require init_file if File.exist?(init_file)
    end

    def task_class
      map = {
        :build      => Build::Final,
        :dry        => Build::Dry,
      }
      map[@options.task] || fallback_task_class
    end

    def fallback_task_class 
      class_name = @options.task.to_s.split('_').map(&:capitalize).join
      begin
        eval("::Texas::Task::#{class_name}")
      rescue
        puts "Failed to fallback for Texas::Task::#{class_name}"
        exit
      end
    end
  end
end
