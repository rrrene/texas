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

      def self.directories_to_watch
        arr = []
        arr << "tex"      if Dir.exists?("tex")
        arr << "contents" if Dir.exists?("contents")
        arr << "figures"  if Dir.exists?("figures")
        arr << Texas.texas_dir
        arr
      end

      def self.rebuild
        started_at = Time.now.to_i
        Build::Final.run(run_options)
        finished_at = Time.now.to_i
        puts (finished_at - started_at).to_s + " seconds to rebuild"
      rescue Exception => e
        puts @build.current_template.filename
        puts "[ERROR] while building \n#{e}"
      end

    end
  end
end
