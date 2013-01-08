require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Build::Base do
  describe "#ran_templates" do

    it "returns the templates" do
      run_scenario "basic-tex" do |runner|
        build = runner.task_instance
        filenames = build.ran_templates.map(&:filename)
        basenames = filenames.map { |f| f.gsub(build.__path__+'/', '') }
        basenames.size.should > 0
      end
    end

  end
end
