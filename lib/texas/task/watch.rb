require 'listen'

module Texas
  module Task
    class Watch < Base
      class << self
        attr_accessor :run_options
      end

      def run
        self.class.run_options = options
        dirs = Task::Watch.directories_to_watch
        Listen.to(*dirs) do |modified, added, removed|
          Task::Watch.rebuild
        end
      end

      class << self
        include Texas::OutputHelper

        def directories_to_watch
          [Texas.contents_subdir_name, Texas.texas_dir]
        end

        def rebuild
          started_at = Time.now.to_i
          Build.run_with_nice_errors Build::Final.new(run_options)
          finished_at = Time.now.to_i
          trace (finished_at - started_at).to_s + " seconds to rebuild"
        end
      end
    end
  end
end
