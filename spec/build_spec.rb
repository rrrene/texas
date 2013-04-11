require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Texas::Build::Base do
  describe "#ran_templates" do

    it "returns the templates" do
      run_scenario "basic-md" do |runner|
        build = runner.task_instance
        filenames = build.ran_templates.map(&:filename)
        basenames = filenames.map { |f| f.gsub(build.__path__+'/', '') }
        basenames.size.should > 0
        basenames.include?("unused_template.tex.erb").should == false
      end
    end

  end
end
