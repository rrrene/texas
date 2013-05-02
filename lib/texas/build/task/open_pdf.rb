module Texas
  module Build
    module Task
      class OpenPDF < Script
        DEFAULT_OPEN_CMD = 'evince #{build.dest_file}'

        def cmd
          cmd_from_config :open, DEFAULT_OPEN_CMD
        end

        def run
          return unless build.options.open_pdf
          if cmd
            execute cmd
          else
            trace "Can't open PDF: no default command recognized. Specify in #{Build::Base::CONFIG_FILE}"
          end
        end

      end
    end
  end
end
