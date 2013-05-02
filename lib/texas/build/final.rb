module Texas
  module Build
    class Final < Dry
      append_after_task :PublishPDF, :ExecuteAfterScripts, :OpenPDF
    end
  end
end
