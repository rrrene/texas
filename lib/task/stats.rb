module Task
  class Stats < Base
    def run
      puts build.ran_templates.join("\n  ")
    end
  end
end