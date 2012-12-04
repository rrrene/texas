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

      def input(*path)
        tex :input, input_path(path)
      end

      def i(text)
        tex :emph, text
      end

      def input!(*path)
        tex :include, input_path(path)
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

      # Searches for the given file in +possible_paths+, also checking for +possible_exts+ as extensions
      #
      # Example:
      #   file(["figures", "titel"], [:pdf, :png])
      #   # => will check
      #          figures/titel.pdf
      #          figures/titel.png
      #          tmp/figures/titel.pdf
      #          tmp/figures/titel.png
      #
      def file(parts, possible_exts = [], possible_paths = base_search_paths)
        possible_paths.each do |base|
          ([""] + possible_exts).each do |ext|
            path = parts.clone.map(&:to_s).map(&:dup)
            path.unshift base.to_s
            path.last << ".#{ext}" unless ext.empty?
            filename = File.join(*path)
            return filename if File.exist?(filename) && !File.directory?(filename)
          end
        end
        nil
      end

      # Searches for the given file and raises an error if it is not found anywhere
      #
      def file!(parts, possible_exts = [], possible_paths = base_search_paths)
        if filename = file(parts, possible_exts, possible_paths)
          filename
        else
          raise "File doesnot exists anywhere: #{parts.inspect}#{possible_exts.inspect} in #{possible_paths.inspect} #{}"
        end
      end

      # Returns a path relative to the build_path and strips the TeX extension
      #
      # Example:
      #   input_path("/home/rene/github/dissertation/expose/tmp/build/contents.tex.erb")
      #   # => "contents"
      #
      def input_path(path)
        filename = relative_template_path(path)
        value = filename.gsub(/\.tex$/, '').gsub(/\.tex\.erb$/, '')
      end

      def base_search_paths
        [build_path, root, tmp_path]
      end

      def input_search_paths
        subdir = @output_filename.gsub(build_path, '').gsub('.tex', '')
        subdir = File.join(build_path, subdir)
        arr = base_search_paths
        arr << subdir if File.exist?(subdir)
        arr
      end

      def partial(name, locals = {})
        filename = file!(["_#{name}"], %w(tex tex.erb))
        Template.create(filename, build).render(locals)
      end

      # Returns a path relative to the build_path
      #
      # Example:
      #   relative_template_path("/home/rene/github/dissertation/expose/tmp/build/00_titelseite")
      #   # => "00_titelseite"
      #
      def relative_template_path(path, possible_exts = %w(tex tex.erb), base_path = build_path)
        filename = file!(path, possible_exts, input_search_paths)
        filename.gsub(base_path+'/', '')
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
