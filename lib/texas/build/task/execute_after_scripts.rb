module Texas
  module Build
    module Task
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
