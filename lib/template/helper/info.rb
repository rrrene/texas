# encoding: UTF-8
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

    end
  end
end
