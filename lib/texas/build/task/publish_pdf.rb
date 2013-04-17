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
          run_pdflatex
          copy_pdf_file_to_dest_dir
        end

        def copy_pdf_file_to_dest_dir
          tmp_file = File.join(build_path, "#{File.basename(master_file, '.tex')}.pdf")
          FileUtils.mkdir_p File.dirname(dest_file)
          FileUtils.copy tmp_file, dest_file
          verbose { verbose_info }
        end

        def run_pdflatex
          verbose { "Running pdflatex in #{build_path} ..." }
          run_in build_path do
            `pdflatex #{File.basename(master_file)}`
            `pdflatex #{File.basename(master_file)}`
          end
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
