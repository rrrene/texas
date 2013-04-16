require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Texas::Build::Base do

  def test_build
    @test_build ||= get_runner_instance
  end

  def get_runner_instance
    run_scenario "basic" do |runner|
      return runner.task_instance
    end
  end

  describe "#ran_templates" do
    it "returns the templates" do
      filenames = test_build.ran_templates.map(&:filename)
      basenames = filenames.map { |f| f.gsub(test_build.__path__+'/', '') }
      basenames.size.should > 0
      basenames.include?("unused_template.tex.erb").should == false
    end
  end

  class FoobarTask
    class << self
      attr_accessor :foo
    end

    def initialize(*args)
    end

    def run
      self.class.foo = :bar
    end
  end

  describe "#run_build_task" do
    it "should instanciate the given class and call the run method" do
      FoobarTask.foo.nil?.should == true
      test_build.run_build_task FoobarTask
      FoobarTask.foo.should == :bar
    end
  end
  
end
