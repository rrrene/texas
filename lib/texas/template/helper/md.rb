# encoding: UTF-8
module Texas
  module Template
    module Helper
      module Markdown

        def chapter(opts = {})
          if glob = opts[:glob]
            opts[:templates] = templates_by_glob(glob)
          end
          document.__chapters__ ||= []
          document.__chapters__ << opts
          partial(:chapter, opts)
        end

        def center(str)
          "\\begin{center}#{str}\\end{center}"
        end

        def gray(text)
          "\\textcolor{gray}{#{text}}"
        end

        def page_break
          "\\clearpage"
        end

        def scene_delimiter
          center gray("* * *")
        end

      end
    end
  end
end
