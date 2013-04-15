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

    #
    # Return a structure describing the options.
    #
    def parse
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options.task = :build
      options.work_dir = find_work_dir
      options.check_mandatory_arguments = true
      options.load_local_libs = true
      options.contents_dir = Texas.contents_subdir_name
      options.contents_template = find_contents_file("contents")
      options.colors = true
      options.merge_config = nil
      options.verbose = false
      options.warnings = true
      options.open_pdf = true

      lookup_and_execute_require_option(args)
      
      opts = ::OptionParser.new do |opts|
        opts.banner = "Usage: texas [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-d", "--dry-run", "Run without pdf generation") do |contents_template|
          options.task = :dry
        end

        opts.on("-m", "--merge-config [CONFIG]",
                "Merge config with key from .texasrc") do |key|
          options.merge_config = key
        end

        opts.on("-n", "--new [NAME]",
                "Create new texas project directory") do |name|
          options.task = :new_project
          options.check_mandatory_arguments = false
          options.load_local_libs = false
          options.new_project_name = name
        end

        opts.on("-r", "--require [LIBRARY]", "Require library before running texas") do |lib|
          # this block does nothing
          # require was already performed by lookup_and_execute_require_option
          # this option is here to ensure the -r switch is listed in the help option
        end

        opts.on("--watch", "Watch the given template") do |contents_template|
          options.task = :watch
          options.open_pdf = false
        end

        parse_additional_options(opts)

        opts.separator ""
        opts.separator "Common options:"

        # Boolean switch.
        opts.on("-c", "--[no-]color", "Switch colors") do |v|
          options.colors = v
        end

        # Boolean switch.
        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options.verbose = v
        end

        # Boolean switch.
        opts.on("-w", "--[no-]warnings", "Switch warnings") do |v|
          options.warnings = v
        end

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Show version") do
          puts Texas::VERSION::STRING
          exit
        end
      end

      opts.parse!(args)

      unless args.empty?
        f = args.shift
        options.contents_template = find_contents_file(f)
        options.contents_dir = find_contents_dir(f)
      end
      if options.check_mandatory_arguments
        check_mandatory! options
      end
      options
    end

    private

    # This method can be overwritten by other libraries
    # to parse additional options
    def parse_additional_options(opts)
    end
    
    def lookup_and_execute_require_option(args)
      args.each_with_index do |v, i|
        if %w(-r --require).include?(v)
          require args[i+1]
        end
      end
    end

    def check_mandatory!(options)
      if options.work_dir.nil?
        warn "texas: missing file operand\nTry `texas --help' for more information."
        exit 1
      end
      if options.contents_template.nil?
        warn "texas: could not find contents template\nTry `texas --help' for more information."
        exit 1
      end
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
  end

end