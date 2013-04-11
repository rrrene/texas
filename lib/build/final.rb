module Build
  class Final < Dry
    prepend_after_task :AddClearlyMissingAbbrevs
    append_after_task :PublishPDF, :OpenPDF
  end
end
