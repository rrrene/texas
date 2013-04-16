# encoding: UTF-8
module Texas
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

        # Returns a subdir with the current template's basename
        #
        # Example:
        # In /example/introduction.tex.erb this method 
        # returns "/example/introduction" if that directory exists
        # and nil if it doesn't.
        #
        def path_with_templates_basename
          subdir = Template.basename @output_filename
          File.directory?(subdir) ? subdir : nil
        end

        # Searches for the given file in +possible_paths+, also checking for +possible_exts+ as extensions
        #
        # Example:
        #   find_template_file(["figures", "some-chart"], [:pdf, :png], ["", "tmp", "tmp/build"])
        #   # => will check
        #          figures/some-chart.pdf
        #          figures/some-chart.png
        #          tmp/figures/some-chart.pdf
        #          tmp/figures/some-chart.png
        #          tmp/build/figures/some-chart.pdf
        #          tmp/build/figures/some-chart.png
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
            raise TemplateError.new(self, "File doesn't exists anywhere: #{parts.size > 1 ? parts : parts.first}")
          end
        end

        # Renders a partial with the given locals.
        #
        def partial(name, locals = {})
          render("_#{name}", locals)
        end

        # Renders a template with the given locals.
        #
        def render(options, locals = {})
          if [String, Symbol].include?(options.class)
            options = {:templates => [options]}
          end
          if name = options[:template]
            options[:templates] = [name]
          end
          if glob = options[:glob]
            options[:templates] = templates_by_glob(glob)
          end
          options[:locals] = locals unless locals.empty?
          render_as_array(options).join(options[:join].to_s)
        end

        def render_as_array(options)
          options[:templates].map do |name|
            template_file = find_template_file!([name], template_extensions)
            Texas::Template.create(template_file, build).__run__(options[:locals])
          end
        end

        # Returns all extensions the Template::Runner can handle.
        #
        def template_extensions
          Texas::Template.known_extensions
        end

        # Returns all templates in the current template's path matching the given glob
        #
        def templates_by_glob(glob = "*") 
          files = Dir[File.join(__path__, glob)]
          templates = files.map do |f| 
            Texas::Template.basename(f).gsub(__path__, '') 
          end
          templates.uniq.sort
        end

      end
    end
  end
end
