require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Template::Runner::Base do

  def test_template(_runner)
    build = _runner.task_instance
    template_filename = File.join(build.__path__, "contents.tex.erb")
    Template.create( template_filename, build )
  end

  describe "#info" do
    it "should return an info object for the given template" do
      run_scenario "basic" do |runner|
        template = test_template(runner)
        template.__run__
        template.info.should_not be_nil
      end
    end
  end
  
  describe "#abstract" do
    it "should return an info object for the given template" do
      run_scenario "basic" do |runner|
        template = test_template(runner)
        template.__run__
        template.abstract.should == "This is a one-liner to describe the contents of this template"
      end
    end
  end
  
  describe "#summary" do
    it "should return an info object for the given template" do
      run_scenario "basic" do |runner|
        template = test_template(runner)
        template.__run__
        template.summary.should == "This is a more elaborate summary of the contents of this template!"
      end
    end
  end
  
end
