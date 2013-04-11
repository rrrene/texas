module Texas
  module Task
    class Citations < Base
      def run
        if citations.empty?
          puts "No citations found!"
        else
          puts "#" + " Citations" 
          last_template = nil
          already_put = []
          citations.each do |citation|
            template = citation[0]
            info = citation[1]
            if template != last_template
              puts "#"
              puts "#" + " " + rel_path(template).cyan
              last_template = template
              already_put = []
            end
            unless already_put.include?(info)
              puts "#" + "   #{info.first}: #{info.last.join(', ')}"
              already_put << info
            end
          end
          puts "#"
          if citation_author
            pages = citations.map { |c| c[1].last }.flatten.uniq
            sorted = pages.sort do |a, b| 
              a.gsub(/^\D+/, '').to_i <=> b.gsub(/^\D+/, '').to_i
            end
            puts "Sorted: #{sorted.join(', ')}"
          end
        end
      end

      def citations
        @citations ||= if citation_author
          track.__citations__.select { |c| c[1].first.include?(citation_author) }
        else
          track.__citations__
        end
      end

      def citation_author
        options.citation_author
      end

      def rel_path(filename)
        filename.to_s.gsub(build.build_path, '')
      end

    end
  end
end
