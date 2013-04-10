module Build
  class Final < Base

    def after_tasks
      tasks = ["AddClearlyMissingAbbrevs", __after_tasks__, "PublishPDF"]
      tasks << "OpenPDF" if options.open_pdf
      tasks.flatten
    end

  end
end
