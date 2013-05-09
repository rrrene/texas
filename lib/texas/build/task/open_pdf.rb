module Texas
  module Build
    module Task
      # This build task opens the generated PDF file.
      #
      class OpenPDF < Script
        DEFAULT_OPEN_CMD = 'evince "<%= build.dest_file %>"'

        def cmd
          cmd_from_config :open, DEFAULT_OPEN_CMD
        end

        def run
          if cmd && build.options.open_pdf
            execute cmd
          end
        end

      end
    end
  end
end
