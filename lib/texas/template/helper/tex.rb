# encoding: UTF-8
module Texas
  module Template
    module Helper
      module TeX

        # Converts all URLs in a text in \url TeX commands
        #
        def auto_link(text)
          text.to_s.gsub(/(https*\:\/\/\S+)/, '\url{\1}')
        end

        def bold(text)
          tex :textbf, text
        end
        alias b bold

        def h1(*args); tex(:section, *args); end
        def h2(*args); tex(:subsection, *args); end
        def h3(*args); tex(:subsubsection, *args); end
        def h4(text); '\paragraph{'+text+'} ~\\'; end

        def italic(text)
          tex :emph, text
        end
        alias i italic

        def input(*path)
          write_template_for_input(path)
          tex :input, relative_template_basename(path)
        end

        def input!(*path)
          write_template_for_input(path)
          tex :include, relative_template_basename(path)
        end

        def linebreak
          "\\\\"
        end
        alias br linebreak
        
        def quote(string)
          "\"`#{string}\"'"
        end

        def write_template_for_input(path)
          filename = find_template_file!(path, template_extensions)
          template = Template.create(filename, build)
          template.write
        end

        private

        # Returns a path relative to the build_path
        #
        # Example:
        #   input_path("/home/rene/github/sample_project/tmp/build/contents.tex.erb")
        #   # => "contents.tex.erb"
        #
        def relative_template_filename(path, possible_exts = Template.known_extensions)
          filename = find_template_file!(path, possible_exts)
          filename.gsub(build_path+'/', '')
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

        def tex(command, text)
          "\\#{command}{#{text}}"
        end

      end
    end
  end
end
