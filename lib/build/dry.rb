module Build
  class Dry < Base

    # just copy tex/* and run all ERb templates
    def run
      copy_and_run_templates
    end

  end

end

