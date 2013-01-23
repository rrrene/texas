module Sources
  module Reference
    class Entry < Base
    
      def build
        @runner.build
      end

      def enumerate_pages(list)
        enumerate list, " u. "
      end

      def literatur
        build.literatur
      end

      def sources
        slices = @parts.slice_before { |a| a.is_a?(Symbol) }.to_a
        slices.map do |list|
          key = list.shift
          source = literatur[key]
          pages = list.map do |page|
            if page =~ /\df/
              warning { "Found wrong #{'folgende'.black.on_yellow} notation: #{runner.filename}" }
            end
            if page == list.first
              page
            else
              page.gsub("S. ", "")
            end
          end
          build.track.citation(key, pages)
          build.track.miscitation(key) if pages.to_s.empty?
          str = "\\textsc{#{source.label}}" # TODO: this is LaTeX specific
          str << ", #{enumerate_pages pages}" unless pages.empty?
          str
        end

      end

    end
  end
end
