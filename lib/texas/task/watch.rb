require 'listen'

module Texas
  module Task
    class Watch < Base
      class << self
        attr_accessor :run_options
      end

      def run
        self.class.run_options = options.to_h.merge(:task => :build)
        dirs = Task::Watch.directories_to_watch
        listener = Listen.to(*dirs) do |modified, added, removed|
          Task::Watch.rebuild
        end
        Task::Watch.rebuild
        listener.start
        sleep
      end

      class << self
        include Texas::CLI::OutputHelper

        # Returns the directories watched by default.
        #
        def default_directories
          [Texas.contents_subdir_name, "lib/", Texas.texas_dir]
        end

        # Returns the directories watched, which can be extended.
        #
        # Example:
        #   Texas::Task::Watch.directories << "images/"
        #
        def directories
          @@directories ||= default_directories
        end

        def directories_to_watch
          directories.uniq.select { |d| File.exists?(d) }
        end

        def rebuild
          started_at = Time.now.to_i
          build = Texas::CLI::Runner.new(run_options).task_instance
          finished_at = Time.now.to_i
          time = finished_at - started_at
          trace TraceInfo.new(:rebuild, "in #{time} seconds", :green)
          build
        end
      end
    end
  end
end
