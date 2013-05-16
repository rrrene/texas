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
          ].compact.uniq
        end

        # Returns a subdir with the current template's basename
        #
        # Example:
        #   # Given the following contents directory:
        #   #
        #   # contents/
        #   #   section-1/
        #   #     subsection-1-1.tex.erb
        #   #   contents.tex.erb
        #   #   section-1.tex-erb
        #   #   section-2.tex-erb
        #   #
        #
        #   # section-1.tex.erb
        #
        #   <%= path_with_templates_basename %>
        #   # => "section-1"
        #   
        #   # section-2.tex.erb
        #
        #   <%= path_with_templates_basename %>
        #   # => nil
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
            (possible_exts + [""]).each do |ext|
              filename = filename_for_find(parts, base, ext)
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
            raise TemplateNotFound.new(self, "File doesn't exists anywhere: #{parts.size > 1 ? parts : parts.first}")
          end
        end

        def filename_for_find(parts, base, ext = nil)
          path = [parts].flatten.map(&:to_s).map(&:dup)
          path.unshift base.to_s
          path.last << ".#{ext}" unless ext.empty?
          File.join(*path)
        end

        # Renders a partial with the given locals.
        #
        # Example:
        #   <%= partial :some_partial, :some_value => 42 %>
        #   
        def partial(name, locals = {})
          render("_#{name}", locals)
        end

        # Renders one or more templates with the given locals.
        #
        # Example:
        #   <%= render :template => "some_template" %>
        #   
        #   # or by shorthand:
        #   
        #   <%= render :some_template %>
        #
        #   # or render multiple templates with a single call:
        #   
        #   <%= render %w(some_template some_other_template) %>
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
        # Example:
        #   template_extensions
        #   # => ["tex", "tex.erb", "md", "md.erb"]
        #   
        def template_extensions
          Texas::Template.known_extensions
        end

        # Returns all templates in the current template's path matching the given glob
        #
        # Example:
        #   # Given the following contents directory:
        #   #
        #   # contents/
        #   #   _some_partial.tex.erb
        #   #   contents.tex.erb
        #   #   other_latex.tex
        #   #   other_markdown.md.erb
        #   #   some_template.tex.erb
        #   #
        #
        #   templates_by_glob("*.tex.erb")
        #   # => ["_some_partial", "contents", "other_markdown", "some_template"]
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
