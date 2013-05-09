module Texas
  module Build
    module Task
      # This build task checks the 'after' script in
      # the config's script section and executes it, if present.
      #
      class ExecuteAfterScripts < Script
        def cmd
          cmd_from_config :after
        end

        def run
          execute cmd if cmd
        end
      end
    end
  end
end
