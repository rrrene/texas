module Build
  module Task
    class RunBeforeScripts < Base
      def cmd
        @cmd ||= scripts && scripts['before']
      end

      def scripts
        build.config['script']
      end

      def run
        if cmd
          verbose { "\n[i] Running before script:\n\n    #{cmd.cyan}\n\n" }
          system cmd
        end
      end
    end
  end
end
