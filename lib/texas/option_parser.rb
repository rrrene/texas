require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pathname'

module Texas
  class OptionParser
    attr_reader :args, :options

    def initialize(args)
      @args = args
      @options = OpenStruct.new
    end

    # Return a structure describing the options.
    #
    def parse
      set_default_options
      lookup_and_execute_require_option(args)
      parse_options
      set_contents_template_from_args unless args.empty?
      check_mandatory! if options.check_mandatory_arguments
      options
    end

    private

    def check_mandatory!
      if options.work_dir.nil?
        kill "missing file operand"
      end
      if options.contents_template.nil?
        kill "could not find contents template"
      end
    end

    def kill(msg)
      warn "texas: #{msg}\nTry `texas --help' for more information."
      exit 1
    end

    def find_work_dir(start_dir = Dir.pwd)
      results = Dir[File.join(start_dir, Texas.contents_subdir_name)]
      if !results.empty?
        start_dir
      else
        path = Pathname.new(start_dir)
        if path.realpath.to_s == "/"
          nil
        else
          find_work_dir File.join(start_dir, '..')
        end
      end
    end

    def find_contents_dir(file)
      if Dir["#{file}*"].empty?
        nil
      else
        File.dirname(file)
      end
    end

    def find_contents_file(file)
      file = file.gsub("#{Texas.contents_subdir_name}/", "")
      glob = File.join(Texas.contents_subdir_name, "#{file}*")
      if Dir[glob].empty?
        nil
      else
        file
      end
    end

    # Parses the given arguments for the --require option and requires
    # it if present. This is done separately from the regular option parsing 
    # to enable the required library to modify Texas, 
    # e.g. overwrite OptionParser#parse_additional_options.
    #
    def lookup_and_execute_require_option(args)
      args.each_with_index do |v, i|
        if %w(-r --require).include?(v)
          require args[i+1]
        end
      end
    end

    def parse_options
      parser = ::OptionParser.new do |parser|
        parser.banner = "Usage: texas [CONTENTS_TEMPLATE] [options]"
        parse_specific_options(parser)
        parse_additional_options(parser)
        parse_common_options(parser)
      end
      parser.parse!(args)
    end

    def parse_additional_options(parser)
      if arr = self.class.parse_options_procs
        parser.separator ""
        parser.separator "Custom options:"
        arr.each do |proc|
          proc.(parser, options)
        end
      end
    end

    def self.parse_options_procs
      @@parse_options_procs ||= []
    end

    def self.parse_additional_options(&block)
      parse_options_procs << block
    end

    def parse_common_options(parser)
      parser.separator ""
      parser.separator "Common options:"

      parser.on("--[no-]backtrace", "Switch backtrace") do |v|
        options.backtrace = v
      end

      parser.on("-c", "--[no-]color", "Switch colors") do |v|
        options.colors = v
      end

      parser.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      parser.on("-w", "--[no-]warnings", "Switch warnings") do |v|
        options.warnings = v
      end

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end

      # Another typical switch to print the version.
      parser.on_tail("--version", "Show version") do
        puts Texas::VERSION::STRING
        exit
      end
    end

    # Parses the specific options.
    #
    def parse_specific_options(parser)
      parser.separator ""
      parser.separator "Specific options:"

      parser.on("-d", "--dry-run", "Run without pdf generation") do |contents_template|
        options.task = :dry
      end

      parser.on("-m", "--merge-config [CONFIG]",
              "Merge config with key from .texasrc") do |key|
        options.merge_config = key
      end

      parser.on("-n", "--new [NAME]",
              "Create new texas project directory") do |name|
        options.task = :new_project
        options.check_mandatory_arguments = false
        options.load_local_libs = false
        options.new_project_name = name
      end

      parser.on("-r", "--require [LIBRARY]", "Require library before running texas") do |lib|
        # this block does nothing
        # require was already performed by lookup_and_execute_require_option
        # this option is here to ensure the -r switch is listed in the help option
      end

      parser.on("--watch", "Watch the given template") do |contents_template|
        options.task = :watch
        options.open_pdf = false
      end
    end
    
    def set_default_options
      options.task = :build
      options.work_dir = find_work_dir
      options.check_mandatory_arguments = true
      options.load_local_libs = true
      options.contents_dir = Texas.contents_subdir_name
      options.contents_template = find_contents_file("contents")
      options.backtrace = false
      options.colors = true
      options.merge_config = nil
      options.verbose = false
      options.warnings = true
      options.open_pdf = true
    end

    def set_contents_template_from_args
      f = args.shift
      options.contents_template = find_contents_file(f)
      options.contents_dir = find_contents_dir(f)
    end

  end
end