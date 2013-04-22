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

    def initialize(args = nil)
      @options = options_from_args args
      extend_string_class
      Texas.verbose = @options.verbose
      Texas.warnings = @options.warnings
      load_local_libs if @options.load_local_libs
      @task_instance = task_class.new(@options)
      run
    end
    
    # Display the error message that caused the exception.
    #
    def display_error_message(ex)
      puts "#{@options.task} aborted!"
      puts ex.message
      if @options.backtrace
        puts ex.backtrace
      else
        puts "(See full trace with --backtrace)"
      end
    end

    # Extends String with Term::ANSIColor if options demand it.
    #
    def extend_string_class
      mod = @options.colors ? Term::ANSIColor : Term::NoColor
      String.send :include, mod
    end

    # Load lib/init.rb if present in current project.
    #
    def load_local_libs
      init_file = File.join(@options.work_dir, "lib", "init.rb")
      require init_file if File.exist?(init_file)
    end

    def options_from_args(args)
      if args.is_a?(Hash)
        opts = Texas::OptionParser.new([]).parse
        args.each { |k, v| opts.send("#{k}=", v) }
        opts
      else
        Texas::OptionParser.new(args).parse
      end
    end

    def run
      @task_instance.run
    rescue Exception => ex
      display_error_message ex
      exit 1
    end

    # Returns the class for the given task.
    #
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
