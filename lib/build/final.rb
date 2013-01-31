module Build
  class Final < Base
    def run
      copy_and_run_templates
      
      if options.task == :build
        Task::Test.new(options, self).run
      end

      run_pdflatex
      copy_build_file_to_dest_dir

      open_pdf if options.open_pdf
    end
  end
end
