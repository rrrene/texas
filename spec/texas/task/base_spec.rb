require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Texas::Task::Base do

  describe "#new" do
    it "should not require a build" do
      options = OpenStruct.new
      Texas::Task::Base.new(options)
    end
    it "should take options and a build" do
      options = OpenStruct.new
      build = MockBuild.new
      Texas::Task::Base.new(options, build)
    end
  end

  class MockBuild
    attr_accessor :foo
    
    def initialize(*args); end

    def run
      @foo = :bar
    end
  end

  describe "#run" do
    it "should not raise errors" do
      options = OpenStruct.new
      build = MockBuild.new
      Texas::Task::Base.new(options, build).run
    end
  end
  
  describe "#build" do
    it "should not raise errors" do
      options = OpenStruct.new
      build = MockBuild.new
      task = Texas::Task::Base.new(options, build)
      task.build.should == build
    end
    it "should lazy init the build object" do
      options = OpenStruct.new
      task = Texas::Task::Base.new(options)
      task.build(MockBuild).should_not be_nil
    end
  end

end
