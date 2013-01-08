# encoding: UTF-8
module Template
  module Helper
    #
    # Basic helper methods for finding files and template handling
    #
    module Base

      def default_search_paths
        [
          __path__, 
          path_with_templates_basename, 
          build_path, 
          build.root
        ].compact
      end

      def path_with_templates_basename
        subdir = Template.basename @output_filename
        File.directory?(subdir) ? subdir : nil
      end

      # Searches for the given file in +possible_paths+, also checking for +possible_exts+ as extensions
      #
      # Example:
      #   find_template_file(["figures", "titel"], [:pdf, :png])
      #   # => will check
      #          figures/titel.pdf
      #          figures/titel.png
      #          tmp/figures/titel.pdf
      #          tmp/figures/titel.png
      #
      def find_template_file(parts, possible_exts = [], possible_paths = default_search_paths)
        possible_paths.each do |base|
          ([""] + possible_exts).each do |ext|
            path = parts.clone.map(&:to_s).map(&:dup)
            path.unshift base.to_s
            path.last << ".#{ext}" unless ext.empty?
            filename = File.join(*path)
            return filename if File.exist?(filename) && !File.directory?(filename)
          end
        end
        nil
      end

      # Searches for the given file and raises an error if it is not found anywhere
      #
      def find_template_file!(parts, possible_exts = [], possible_paths = default_search_paths)
        if filename = find_template_file(parts, possible_exts, possible_paths)
          filename
        else
          raise "File doesnot exists anywhere: #{parts.inspect}#{possible_exts.inspect} in #{possible_paths.inspect} #{}"
        end
      end

      def partial(name, locals = {})
        render("_#{name}", locals)
      end

      def render(name, locals = {})
        template_file = find_template_file!([name], template_extensions)
        Template.create(template_file, build).__run__(locals)
      end

      # Returns all extensions the Template::Runner can handle.
      def template_extensions
        Template.known_extensions
      end

      def templates_by_glob(glob = "*") 
        files = Dir[File.join(__path__, o.glob)]
        templates = files.map do |f| 
          Template.basename(f).gsub(__path__, '') 
        end
        templates.uniq.sort
      end

    end
  end
end