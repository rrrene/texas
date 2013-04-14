# encoding: UTF-8
module Texas
  module Template
    module Helper
      module Markdown
        
        def bold(text)
          "**#{text}**"
        end
        alias b bold

        def h1(*args); "# #{args}"; end
        def h1(*args); "## #{args}"; end
        def h1(*args); "### #{args}"; end
        def h1(*args); "#### #{args}"; end

        def italic(text)
          "*#{text}*"
        end
        alias i italic

      end
    end
  end
end
