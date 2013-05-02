module Texas
  module Build
    module Task
      class RunBeforeScripts < Script
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
