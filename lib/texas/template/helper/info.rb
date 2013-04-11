# encoding: UTF-8
module Texas
  module Template
    module Helper
      #
      # Helper methods for describing templates via an info object
      #
      module Info

        def info
          @info ||= OpenStruct.new(:abstract => "", :summary => "")
        end

        def abstract
          info.abstract.strip
        end
        
        def summary
          info.summary.strip
        end

        def marked_for_rewrite?
          !!info.write_at_end_of_build
        end

      end
    end
  end
end
