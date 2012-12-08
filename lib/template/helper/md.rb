# encoding: UTF-8
module Template
  module Helper
    module Markdown

      def chapter(opts = {})
        partial(:chapter, opts)
      end

      def center(str)
        "\\begin{center}#{str}\\end{center}"
      end

      def scene_delimiter
        center "* * *"
      end

    end
  end
end
