module Texas
  module Build
    class << self
      include Texas::CLI::OutputHelper

      # Display the error message that caused the exception.
      #
      def display_error_message(build, ex)
        trace TraceInfo.new(:error, "#{build.options.task} aborted!", :red)
        trace "\n" + ex.message
        if build.options.backtrace
          trace ex.backtrace
        else
          trace "(See full trace with --backtrace)"
        end
      end

      # Run the given build object. If any errors occur, display them in a
      # formatted way and call the optional block, if present.
      #
      def run_with_nice_errors(build, &block)
        build.run
      rescue Interrupt => ex
        trace "\n"
        trace TraceInfo.new("interrupt", "#{build.options.task} interrupted!", :yellow)
        exit 0
      rescue StandardError => ex
        display_error_message(build, ex)
        block.() if block
      end
    end
  end
end

require_relative 'build/config'
require_relative 'build/config_loader'
require_relative 'build/base'
require_relative 'build/dry'
require_relative 'build/final'

require_relative 'build/task/base'
require_relative 'build/task/script'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "build", "task", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
