# encoding: UTF-8
module Template
  module Helper
    module Markdown

      def chapter(title, *templates)
        partial(:chapter, :title => title, :templates => templates)
      end

      def scene_delimiter
        "* * *"
      end

    end
  end
end
