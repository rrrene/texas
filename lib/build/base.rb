require 'digest/sha1'
require 'fileutils'
require 'yaml'
require 'erb'

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

      verbose { "Starting #{self.class}" }
      verbose { "[i] work_dir: #{options.work_dir}".dark }
      verbose { "[i] contents_dir: #{@contents_dir}".dark }
      verbose { "[i] contents_template: #{@contents_template}".dark }
      verbose { "[i] build_path: #{@build_path}".dark }
    end

    def __path__
      File.join(root, 'tmp', 'build')
    end

    def current_template=(t)
      @ran_templates ||= []
      @ran_templates << t unless t.nil?
      @current_template = t
    end

    def document_struct
      @document_struct ||= begin
        hash = config["document"] || {}
        if options.merge_config
          hash.merge! config[options.merge_config]
        end
        OpenStruct.new(hash)
      end
    end
    
    def id
      @id ||= Digest::SHA1.hexdigest(Time.now.to_s) =~ /([a-f].{5})/ && $1
    end

    def config
      @config ||= begin
        filename = File.join(root, CONFIG_FILE)
        File.exist?(filename) ? YAML.load_file(filename) : {}
      end
    end

    def dest_file
      @dest_file ||= File.join(root, "bin", "#{Template.basename contents_template}.pdf")
    end

    def before_tasks
      %w(RunBeforeScripts)
    end
    alias __before_tasks__ before_tasks

    def basic_tasks
      %w(CopyTemplates RunMasterTemplate)
    end
    alias __basic_tasks__ basic_tasks

    def after_tasks
      %w(RewriteMarkedTemplates)
    end
    alias __after_tasks__ after_tasks

    def run_build_tasks(*tasks)
      tasks.flatten.each { |t| run_build_task t }
    end

    def run_build_task(klass)
      klass = eval("::Build::Task::#{klass}") if klass.is_a?(String)
      klass.new(self).run
    end

    def run
      run_build_tasks before_tasks, basic_tasks, after_tasks
    end

    def self.run(options)
      instance = self.new(options)
      instance.run
      instance
    end

  end
end

# TODO: move the following "extension" somewhere else

module Build
  class Base
    # Abbreviations, bibliography and stuff ...

    BIB_FILE = "config/literatur.yml"

    def literatur
      @literatur ||= Sources::Collection.new(YAML.load_file(BIB_FILE))
    end

    def track
      @track ||= Build::Tracker.new(self)
    end

    def bibliography
      citations = track.citations
      keys = citations.map(&:first).uniq.sort
      keys.map { |k| literatur[k] }
    end

  end
end
