
module Sources
  module Reference
    class Figure < Base
      NAMESPACE = "fig"
    
      def sources(add_page_ref = true)
        @parts.map do |key|
          ref = runner.label_id(key, NAMESPACE)
          track.figure_reference(ref)
          str = "Abbildung~\\ref{#{ref}}"
          str << ", S. \\pageref{#{ref}}" if add_page_ref
          str
        end
      end

    end
  end
end
