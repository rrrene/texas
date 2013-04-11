module Texas
  module Build
    class Final < Dry
      append_after_task :PublishPDF, :OpenPDF
    end
  end
end