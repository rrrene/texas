# encoding: UTF-8
module Template
  module Helper
    #
    # Basic helper methods for finding files and template handling
    #
    module Base

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
      def find_template_file(parts, possible_exts = [], possible_paths = base_search_paths)
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
      def find_template_file!(parts, possible_exts = [], possible_paths = base_search_paths)
        if filename = find_template_file(parts, possible_exts, possible_paths)
          filename
        else
          raise "File doesnot exists anywhere: #{parts.inspect}#{possible_exts.inspect} in #{possible_paths.inspect} #{}"
        end
      end

      def glob_templates(glob = "*") 
        files = Dir[File.join(__path__, o.glob)]
        templates = files.map do |f| 
          Template.basename(f).gsub(__path__, '') 
        end
        templates.uniq.sort
      end

      def base_search_paths
        [root, __path__].concat [build_path] # TODO: remove the last one
      end

      def input_search_paths
        subdir = Template.basename @output_filename.gsub(build_path, '')
        subdir = File.join(build_path, subdir)
        arr = base_search_paths
        arr << subdir if File.exist?(subdir)
        arr
      end

      def partial(name, locals = {})
        render("_#{name}", locals)
      end

      def render(name, locals = {})
        template_file = find_template_file!([name], template_extensions)
        Template.create(template_file, build).__render__(locals)
      end

      # Returns all extensions the Template::Runner can handle.
      def template_extensions
        Template.known_extensions
      end

    end
  end
end