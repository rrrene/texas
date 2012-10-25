require 'pp'
require 'option_parser'

require 'build'
require 'core_ext'
require 'find'
require 'sources'
require 'task'
require 'template'
require 'version'

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
  TEX_SUBDIR_NAME = 'tex'

  class << self
    attr_accessor :texas_dir, :verbose, :warnings
  end

  class Runner
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
      task_class.new(@options).run
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
