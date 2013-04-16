require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Texas::Build::Task::PublishPDF do

  def test_build
    run_scenario "basic" do |runner|
      return runner.task_instance
    end
  end

  describe "#run" do
    it "should return an info object for the given template" do
      test_build.run_build_task Texas::Build::Task::PublishPDF
    end
  end
  
end
