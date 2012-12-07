# encoding: UTF-8
module Template
  module Helper
    module TeX

      # References a figure
      #
      def abbildung(*keys)
        Sources::Reference::Figure.new(self, keys)
      end

      # Tracks and outputs an abbreviation
      #
      def abkuerzung(abbreviation, explanation)
        build.track.abbreviation(abbreviation, explanation)
        abbreviation
      end
      alias abk abkuerzung

      def autor(name, include_year = false)
        if name.is_a?(Symbol)
          entry = build.literatur[name.to_s]
          name = entry.label(false)
        end
        tex :textsc, name
      end

      def bibliography
        input! :bibliography
      end

      def bold(text)
        tex :textbf, text
      end
      alias b bold

      # Outputs a figure
      #
      def figure(path, options = {})
        options[:caption] ||= "TODO: Caption"
        options[:label] ||= path
        options[:filename] ||= file!([:figures, path], %w(pdf png))
        build.track.figure(options[:label])
        partial "figure", options
      end
      
      # Outputs a footnote
      #
      def fussnote(*texts)
        tex :footnote, texts.map { |t| auto_link(t) }.join(' ')
      end
      alias f fussnote
      
      def fussnote_quelle(*args)
        fussnote quelle(*args)
      end
      alias fq fussnote_quelle
      
      def fussnote_quelle_abbildung(*args)
        fussnote qa(*args)
      end
      alias fqa fussnote_quelle_abbildung

      def h1(*args); tex(:section, *args); end
      def h2(*args); tex(:subsection, *args); end
      def h3(*args); tex(:subsubsection, *args); end
      def h4(text); '\paragraph{'+text+'} ~\\'; end

      def i(text)
        tex :emph, text
      end

      def input(*path)
        tex :input, relative_template_basename(path)
      end

      def input!(*path)
        tex :include, relative_template_basename(path)
      end

      def internet_verweis(url)
        abkuerzung "URL", "Uniform Resource Locator"
        "Weitere Informationen sind im Internet unter der URL #{url} verfügbar."
      end

      def kapitel(*keys)
        Sources::Reference::Label.new(self, keys)
      end

      def linebreak
        "\\\\"
      end
      alias br linebreak
      
      def quelle(*parts)
        ref = if parts.all? { |p| p.is_a?(Sources::Reference::Base) }
          # TODO: Das muss besser.
          parts.map(&:with_page_ref).join('')
        else
          Sources::Reference::Entry.new(self, parts).with_page_ref
        end
        track_source_related_abbrevs ref.to_s
        ref
      end
      alias q quelle

      def quelle_abbildung(*args)
        if args.empty?
          "Quelle: Eigene Darstellung"
        else
          "Quelle: Eigene Darstellung in Anlehnung an #{autor(args.first)}. " + q(*args)
        end
      end
      alias qa quelle_abbildung

      def quote(string)
        "\"`#{string}\"'"
      end

      # References a figure
      #
      def tabelle(sym)
        build.track.table_reference(sym)
        "Tabelle~\\ref{table:#{sym}}"
      end

      def table(sym, options)
        partial "table", options.merge(:label => sym)
      end

      def table_row(*cells)
        cells.map { |s| 
          if s.to_s.empty?
            "~"
          elsif [true, false].include?(s)
            s ? "x" : "~"
          else
            texify(s)
          end
        }.join(' & ') + ' \\\\'
      end
      alias tr table_row

      # Converts all URLs in a text in \url TeX commands
      #
      def auto_link(text)
        text.to_s.gsub(/(https*\:\/\/\S+)/, '\url{\1}')
      end

      def bad(text)
        "\\textcolor{red}{#{text}}"
      end

      def caption(text)
        "\\caption[#{text}]{#{text}\\protect\\footnotemark}"
      end
      
      def caption_footnote(sources)
        "\\footnotetext{#{quelle_abbildung(*sources)}}"
      end

      def label(key, namespace = "text")
        name =  label_id(key, namespace)
        build.track.label(name)
        tex(:label, name)
      end

      def label_id(key, namespace)
        "#{namespace}:#{key.to_s.downcase.gsub('/', ':')}" 
      end

      private

      def enumerate(arr)
        if arr.size > 1
          arr[0..-2].join(', ') + " sowie " + arr[-1]
        else
          arr[0]
        end
      end

      def tex(command, text)
        "\\#{command}{#{text}}"
      end

      def texify(string)
        string.gsub(/(\%)/) do |m|
          '\\' + m[0]
        end
      end

      def track_source_related_abbrevs(str)
        abk "et al.", "et alii" if str =~ /et\ al\./
        abk "f.", "folgende" if str =~ /\df\./
        abk "ff.", "fortfolgende" if str =~ /\dff\./
        abk "vgl.", "vergleiche" if str =~ /vgl./i
      end
    end
  end
end
