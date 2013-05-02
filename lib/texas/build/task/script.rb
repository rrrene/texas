module Texas
  module Build
    module Task
      class Script < Base
        
        def cmd_from_config(key, default_value = nil)
          if cmd = build.config.script(key) || default_value
            eval('"'+cmd.gsub(/([^\\])(\")/, '\1\"')+'"')
          end
        end

        def execute(cmd)
          verbose { "[i] Running: `#{cmd.cyan}`" }
          execute_in(build.__path__) { `#{cmd}` }
        end

        def execute_in(path)
          old_path = Dir.pwd
          Dir.chdir path
          return_value = yield
          Dir.chdir old_path
          return_value
        end

      end
    end
  end
end
