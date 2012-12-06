require 'fileutils'
require 'yaml'
require 'erb'

module Build
  class Base
    CONFIG_FILE = ".texasrc"
    BIB_FILE = "config/literatur.yml"
    TEX_SOURCE_FILE = "tex/master.tex"
    LISTING_TEMPLATES_REGEX = /verzeichnis/
    PARTIAL_TEMPLATE_REGEX = /^\_/
    DEFAULT_OPEN_CMD = "evince"

    attr_reader :config, :literatur, :track
    attr_reader :root, :tmp_path, :build_path
    attr_reader :source_file, :contents_dir, :dest_file
    attr_reader :current_template
    attr_reader :options, :contents_template, :ran_templates
    attr_reader :left_unknown_abbrevs

    def initialize(_options)
      @options = _options

      @root = options.work_dir
      @contents_template = options.contents_template
      @ran_templates = []

      @config = read_config(CONFIG_FILE) || default_config
      @literatur = Sources::Collection.new(read_config(BIB_FILE))
      @track = Build::Tracker.new(self)

      @tmp_path = File.join(root, 'tmp')
      @source_file = File.join(root, TEX_SOURCE_FILE)

      @dest_file = File.join(root, "bin", "#{contents_template}.pdf")

      @contents_dir = options.contents_dir
      @build_path = File.join(tmp_path, 'build')

      verbose { "Starting #{self.class.to_s.green}" }
      verbose { "+ work_dir: #{options.work_dir}"}
      verbose { "+ contents_dir: #{@contents_dir}"}
      verbose { "+ contents_template: #{@contents_template}"}
      verbose { "+ build_path: #{@build_path}"}

      execute_before_scripts
    end

    def bibliography
      citations = track.citations
      keys = citations.map(&:first).uniq.sort
      keys.map { |k| literatur[k] }
    end

    def current_template=(t)
      @ran_templates << t unless t.nil?
      @current_template = t
    end

    def default_config
      {
        "abbrevs" => {},
        "false_abbrevs" => [],
      }
    end

    def read_config(name)
      filename = File.join(root, name)
      if File.exist?(filename)
        default_config.merge YAML.load_file(filename)
      else
        nil
      end
    end

    def copy_build_file_to_dest_dir
      tmp_file = File.join(build_path, "#{File.basename(source_file, '.tex')}.pdf")
      FileUtils.mkdir_p File.dirname(dest_file)
      FileUtils.copy tmp_file, dest_file
      verbose {
        file = File.join(build_path, "master.log")
        output = `grep "Output written on" #{file}`
        numbers = output.scan(/\((\d+?) pages\, (\d+?) bytes\)\./).flatten
        @page_count = numbers.first.to_i
        "Written PDF in #{dest_file.gsub(root, '')} (#{@page_count} pages)"
      }
    end

    def add_clearly_missing_abbreviations
      missing_abbrevs = found_abbrevs - tracked_abbrevs
      known_abbrevs = missing_abbrevs & config["abbrevs"].keys
      false_abbrevs = [ config["false_abbrevs"] ].flatten.compact
      known_abbrevs.each do |key|
        track.abbreviation(key, config["abbrevs"][key])
      end

      @left_unknown_abbrevs = missing_abbrevs - known_abbrevs - false_abbrevs
      @left_unknown_abbrevs.select! { |a| !known_abbrevs.map(&:downcase).include?(a.downcase) }

      verbose { "Adding known abbrevs: " + known_abbrevs.inspect } unless known_abbrevs.empty?
    end

    def execute_before_scripts
      if config['script']
        if cmd = config['script']['before']
          verbose { "Runnung before script:\n  #{cmd.cyan}" }
          system cmd
        end
      end
    end

    def find(*use_classes)
      compiled_files = Dir[File.join(build_path, "**/*.tex")]
      found = []
      use_classes.flatten.each do |klass|
        found << klass.new(compiled_files).to_a
      end
      found.flatten.uniq.sort
    end

    def found_abbrevs
      find Find::Abbreviations, Find::Acronyms
    end
    
    def copy_to_build_path
      begin
        FileUtils.mkdir_p build_path
      rescue
        # ...
      end
      FileUtils.rm_r build_path
      File.join(Texas.texas_dir, Texas.contents_subdir_name)
      FileUtils.cp_r contents_dir, build_path
      glob = File.join(Texas.texas_dir, Texas.contents_subdir_name, '*.*')
      Dir[glob].each do |filename|
        dest = File.join(build_path, File.basename(filename))
        unless File.exists?(dest)
          FileUtils.cp filename, build_path
        end
      end
    end

    def copy_and_run_templates
      copy_to_build_path
      run_all_templates
    end

    def run_all_templates
      run_templates_for_content
      add_clearly_missing_abbreviations
      run_templates_for_listings
    end

    def run_templates(arr)
      arr.each { |t| Template.create(t, self).write }
    end

    def run_templates_for_content
      run_templates templates.select { |t| t !~ LISTING_TEMPLATES_REGEX }
    end

    def run_templates_for_listings
      run_templates templates.select { |t| t =~ LISTING_TEMPLATES_REGEX }
    end

    def run_pdflatex
      verbose { "Running pdflatex in #{build_path} ..." }
      Dir.chdir build_path
      `pdflatex #{File.basename(source_file)}`
      `pdflatex #{File.basename(source_file)}`
    end

    def open_pdf
      if open_pdf_cmd
        system "#{open_pdf_cmd} #{dest_file}"
      else
        puts "Can't open PDF: no default command recognized. Specify in #{CONFIG_FILE}"
      end
    end

    def open_pdf_cmd
      cmd = `which #{DEFAULT_OPEN_CMD}`.strip
      if config["script"]
        cmd = config["script"]["open"] || cmd
      end
      cmd.empty? ? nil : cmd
    end

    def run
      raise "Implement me!"
    end

    def self.run(options)
      build = self.new(options)
      build.run
      build
    end

    def templates
      all = Dir[File.join(build_path, "**/*")]
      all.select { |t| File.basename(t) !~ PARTIAL_TEMPLATE_REGEX }
    end

    def tracked_abbrevs
      track.abbreviations.map(&:first).uniq
    end
  end
end
