require 'yaml'

module Texas
  module Build
    class Base
      include Texas::CLI::OutputHelper
      CONFIG_FILE = ".texasrc"
      MASTER_TEMPLATE = "master.tex"

      # Returns the path of the current Texas project
      attr_reader :root

      # Returns the options of this build.
      attr_reader :options

      # Returns the location of the template that is run.
      attr_reader :master_file

      attr_reader :contents_dir

      # Returns the name of the template whose contents should be rendered.
      attr_reader :contents_template

      # Returns the name of the template currently rendered.
      attr_reader :current_template

      # Returns an array of all templates that have been rendered.
      attr_reader :ran_templates

      def initialize(_options)
        @options = _options
        @root = options.work_dir
        @contents_dir = options.contents_dir
        @contents_template = options.contents_template
        @master_file = File.join(__path__, MASTER_TEMPLATE)
        verbose { verbose_info }
      end

      # Returns the full path of the directory where the build is happening.
      #
      def __path__
        File.join(root, 'tmp', 'build')
      end

      # Returns an object that can store persistent information throughout
      # the build process.
      #
      def store
        @store ||= OpenStruct.new
      end

      # Sets the currently rendered template.
      #
      def current_template=(t)
        @ran_templates ||= []
        @ran_templates << t unless t.nil?
        @current_template = t
      end

      # Returns the Config object.
      #
      def config
        @config ||= Config.create ConfigLoader.new(root, CONFIG_FILE).to_hash, options.merge_config
      end

      # Returns the location where the generated PDF file should be after the build.
      #
      def dest_file
        @dest_file ||= File.join(root, "bin", "#{Template.basename contents_template}.pdf")
      end

      # Runs the given build tasks.
      #
      def run_build_tasks(*tasks)
        tasks.flatten.each { |t| run_build_task t }
      end

      # Runs the given build task.
      #
      def run_build_task(klass)
        verbose { TraceInfo.new(:build_task, klass, :green) }
        klass = eval("::Texas::Build::Task::#{klass}") if [Symbol, String].include?(klass.class)
        klass.new(self).run
      end

      # Executes the build process.
      #
      def run
        run_build_tasks before_tasks, basic_tasks, after_tasks
      end

      def verbose_info
        [
          TraceInfo.new("work_dir", options.work_dir, :dark),
          TraceInfo.new("build_path", __path__, :dark),
        ].join("\n")
      end

      %w(before basic after).each do |method|
        class_eval <<-INSTANCE_EVAL
          def #{method}_tasks
            self.class.tasks(:#{method})
          end
        INSTANCE_EVAL
      end

      class << self
        def tasks(key)
          @@tasks ||= {}
          initialize_tasks if @@tasks[self.to_s].nil?
          @@tasks[self.to_s][key] ||= []
          @@tasks[self.to_s][key]
        end

        def initialize_tasks
          @@tasks[self.to_s] = {}
          (@@tasks[self.superclass.to_s] || {}).each do |k, v|
            @@tasks[self.to_s][k] = v.dup
          end
        end

        %w(before basic after).each do |method|
          class_eval <<-CLASS_EVAL
            def prepend_#{method}_task(*_tasks)
              tasks(:#{method}).unshift(*_tasks)
            end

            def append_#{method}_task(*_tasks)
              tasks(:#{method}).concat(_tasks)
            end
            alias #{method}_task append_#{method}_task
          CLASS_EVAL
        end

      end
    end
  end
end
