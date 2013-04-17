require 'yaml'

module Texas
  module Build
    class Base
      CONFIG_FILE = ".texasrc"
      MASTER_TEMPLATE = "master.tex"

      attr_reader :root, :options
      attr_reader :master_file, :contents_dir, :contents_template
      attr_reader :current_template, :ran_templates

      def initialize(_options)
        @options = _options
        @root = options.work_dir
        @contents_dir = options.contents_dir
        @contents_template = options.contents_template
        @master_file = File.join(__path__, MASTER_TEMPLATE)
        verbose { verbose_info }
      end

      def __path__
        File.join(root, 'tmp', 'build')
      end

      def store
        @store ||= OpenStruct.new
      end

      def current_template=(t)
        @ran_templates ||= []
        @ran_templates << t unless t.nil?
        @current_template = t
      end

      def config
        @config ||= Config.create File.join(root, CONFIG_FILE), options.merge_config
      end

      def dest_file
        @dest_file ||= File.join(root, "bin", "#{Template.basename contents_template}.pdf")
      end

      def run_build_tasks(*tasks)
        tasks.flatten.each { |t| run_build_task t }
      end

      def run_build_task(klass)
        klass = eval("::Texas::Build::Task::#{klass}") if [Symbol, String].include?(klass.class)
        verbose { "[b] #{klass}".dark }
        klass.new(self).run
      end

      def run
        run_build_tasks before_tasks, basic_tasks, after_tasks
      end

      def verbose_info
        [
          "Starting #{self.class}",
          "[i] work_dir: #{options.work_dir}".dark,
          "[i] contents_dir: #{@contents_dir}".dark,
          "[i] contents_template: #{@contents_template}".dark,
          "[i] build_path: #{__path__}".dark
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
