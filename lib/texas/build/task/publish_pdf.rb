module Texas
  module Build
    module Task
      class PublishPDF < Base

        def master_file
          build.master_file
        end

        def build_path
          build.__path__
        end

        def dest_file
          build.dest_file
        end

        def run
          compile_pdf
          if compile_pdf_successfull?
            compile_pdf # again
            copy_pdf_file_to_dest_dir
          else
            run_in(build_path) { puts `cat #{tex_log_file}` }
            raise "Error while running: `#{latex_cmd}`"
          end
        end
        
        def compile_pdf_successfull?
          $?.to_i == 0
        end
        
        def copy_pdf_file_to_dest_dir
          tmp_file = File.join(build_path, "#{File.basename(master_file, '.tex')}.pdf")
          FileUtils.mkdir_p File.dirname(dest_file)
          FileUtils.copy tmp_file, dest_file
          verbose { verbose_info }
        end
        
        def latex_cmd
          "pdflatex -halt-on-error #{File.basename(master_file)}"
        end

        def compile_pdf
          run_in(build_path) { `#{latex_cmd}` }
        end
        
        def run_in(path)
          old_path = Dir.pwd
          Dir.chdir path
          yield
          Dir.chdir old_path
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
