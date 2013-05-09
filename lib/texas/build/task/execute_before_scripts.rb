module Texas
  module Build
    module Task
      # This build task checks the 'before' script in
      # the config's script section and executes it, if present.
      #
      class ExecuteBeforeScripts < Script
        def cmd
          cmd_from_config :before
        end

        def run
          execute cmd if cmd
        end
      end
    end
  end
end
