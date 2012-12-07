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
      #   file(["figures", "titel"], [:pdf, :png])
      #   # => will check
      #          figures/titel.pdf
      #          figures/titel.png
      #          tmp/figures/titel.pdf
      #          tmp/figures/titel.png
      #
      def file(parts, possible_exts = [], possible_paths = base_search_paths)
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
      def file!(parts, possible_exts = [], possible_paths = base_search_paths)
        if filename = file(parts, possible_exts, possible_paths)
          filename
        else
          raise "File doesnot exists anywhere: #{parts.inspect}#{possible_exts.inspect} in #{possible_paths.inspect} #{}"
        end
      end

      def base_search_paths
        [build_path, root, tmp_path]
      end

      def input_search_paths
        subdir = @output_filename.gsub(build_path, '').gsub('.tex', '')
        subdir = File.join(build_path, subdir)
        arr = base_search_paths
        arr << subdir if File.exist?(subdir)
        arr
      end

      def partial(name, locals = {})
        render("_#{name}", locals)
      end

      # Returns a path relative to the build_path
      #
      # Example:
      #   relative_template_path("/home/rene/github/sample_project/tmp/build/00_titelseite")
      #   # => "00_titelseite"
      #
      def relative_template_filename(path, possible_exts = template_extensions, base_path = build_path)
        filename = file!(path, possible_exts, input_search_paths)
        filename.gsub(base_path+'/', '')
      end

      # Returns a path relative to the build_path and strips the template extension
      #
      # Example:
      #   input_path("/home/rene/github/sample_project/tmp/build/contents.tex.erb")
      #   # => "contents"
      #
      def relative_template_basename(path)
        Template.basename relative_template_filename(path)
      end

      def render(name, locals = {})
        template_file = file!([name], template_extensions)
        Template.create(template_file, build).render_to_string(locals)
      end

      # Returns all extensions the Template::Runner can handle.
      def template_extensions
        Template.known_extensions
      end

    end
  end
end