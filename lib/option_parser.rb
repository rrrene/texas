require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pathname'

module Texas
  class OptionParser
    class << self
      #
      # Return a structure describing the options.
      #
      def parse(args)
        # The options specified on the command line will be collected in *options*.
        # We set default values here.
        options = OpenStruct.new
        options.task = :build
        options.work_dir = find_work_dir
        options.contents_dir = Texas.contents_subdir_name
        options.contents_template = find_contents_file("contents")
        options.citation_author = nil
        options.colors = true
        options.merge_config = nil
        options.verbose = false
        options.warnings = true
        options.open_pdf = true

        opts = ::OptionParser.new do |opts|
          opts.banner = "Usage: texas [options]"

          opts.separator ""
          opts.separator "Specific options:"

          opts.on("-b", "--build",
                  "Build the given template") do |contents_template|
            options.task = :build
          end

          opts.on("-c", "--citations [AUTHOR]",
                  "Output the given AUTHOR's citations") do |author|
            options.task = :citations
            options.citation_author = author
          end

          opts.on("-d", "--dry-run", "Run without pdf generation") do |contents_template|
            options.task = :dry
          end

          opts.on("-s", "--stats",
                  "Output stats") do |contents_template|
            options.task = :stats
          end

          opts.on("--summary",
                  "Output summaries") do |contents_template|
            options.task = :summary
          end

          opts.on("--task [TASK]",
                  "Use custom task") do |task|
            options.task = task
          end

          opts.on("-m", "--merge-config [CONFIG]",
                  "Merge document config with custom key from .texasrc") do |key|
            options.merge_config = key
          end

          opts.on("-t", "--test",
                  "Test the given template") do |contents_template|
            options.task = :test
          end

          opts.on("--watch",
                  "Test the given template") do |contents_template|
            options.task = :watch
            options.open_pdf = false
          end

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

          opts.separator ""
          opts.separator "Common options:"

          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opts.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end

          # Another typical switch to print the version.
          opts.on_tail("--version", "Show version") do
            puts ::OptionParser::Version.join('.')
            exit
          end
        end

        opts.parse!(args)
        unless args.empty?
          f = args.shift
          options.contents_template = find_contents_file(f)
          options.contents_dir = find_contents_dir(f)
        end
        check_mandatory! options
        options
      end  # parse()

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
end