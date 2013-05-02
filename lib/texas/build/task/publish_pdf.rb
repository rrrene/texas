module Texas
  module Build
    module Task
      class PublishPDF < Base
        DEFAULT_COMPILE_CMD = 'pdflatex -halt-on-error "#{File.basename(build.master_file)}"'

        def build_path
          build.__path__
        end

        def dest_file
          build.dest_file
        end

        def run
          verbose { "Running: `#{compile_cmd}`" }
          latex_cmd_output = compile_pdf
          if compile_pdf_successfull?
            compile_pdf # again
            copy_pdf_file_to_dest_dir
          else
            trace latex_cmd_output
            raise "Error while running: `#{compile_cmd}`"
          end
        end
        
        def compile_pdf_successfull?
          $?.to_i == 0
        end
        
        def copy_pdf_file_to_dest_dir
          basename = File.basename(build.master_file, '.tex')
          tmp_file = File.join(build_path, "#{basename}.pdf")
          FileUtils.mkdir_p File.dirname(dest_file)
          FileUtils.copy tmp_file, dest_file
          verbose { verbose_info }
        end
        
        def compile_cmd
          @compile_cmd ||= begin
            cmd = build.config.script(:compile) || DEFAULT_COMPILE_CMD
            eval('"'+cmd.gsub(/([^\\])(\")/, '\1\"')+'"')
          end
        end

        def compile_pdf
          run_in(build_path) { `#{compile_cmd}` }
        end
        
        def run_in(path)
          old_path = Dir.pwd
          Dir.chdir path
          return_value = yield
          Dir.chdir old_path
          return_value
        end

        def tex_log_file
          File.join(build_path, "master.log")
        end

        def verbose_info
          output = `grep "Output written on" #{tex_log_file}`
          numbers = output.scan(/\((\d+?) pages?\, (\d+?) bytes\)\./).flatten
          @page_count = numbers.first.to_i
          "Written PDF in #{dest_file.gsub(build.root, '')} (#{@page_count} pages)".green
        end

      end
    end
  end
end
