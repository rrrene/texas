require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Texas::Build::Task::Base do

  describe "#new" do
    it "should not require a build" do
      Texas::Build::Task::Base.new()
    end
    it "should take a build" do
      build = Object.new
      Texas::Build::Task::Base.new(build)
    end
  end

  describe "#run" do
    it "should not raise errors" do
      Texas::Build::Task::Base.new.run
    end
  end
  
end
