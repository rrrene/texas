module Texas
  module Sources
    module Reference
      class Label < Base
      
        def sources(add_page_ref = true)
          @parts.map do |key|
            ref = runner.label_id(key, "text")
            track.label_reference(ref)
            str = "Kapitel~\\ref{#{ref}}"
            str << ", S. \\pageref{#{ref}}" if add_page_ref
            str
          end
        end

      end
    end
  end
end