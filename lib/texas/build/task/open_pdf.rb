module Texas
  module Build
    module Task
      class OpenPDF < Base
        DEFAULT_OPEN_CMD = "evince"

        def cmd
          @cmd ||= scripts && scripts['open']
        end

        def scripts
          build.config['script']
        end

        def run
          return unless build.options.open_pdf
          if open_pdf_cmd
            system "#{open_pdf_cmd} #{build.dest_file}"
          else
            puts "Can't open PDF: no default command recognized. Specify in #{CONFIG_FILE}"
          end
        end

        def open_pdf_cmd
          if cmd
            cmd
          else
            default = `which #{DEFAULT_OPEN_CMD}`.strip
            default.empty? ? nil : default
          end
        end

      end
    end
  end
end
