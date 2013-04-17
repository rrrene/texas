require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Texas::Build::Base do

  def fake_options
    options = OpenStruct.new({
      :work_dir => "/tmp/test_project",
      :contents_dir => "contents",
      :contents_template => "contents"
      })
  end

  def fake_build
    Texas::Build::Base.new(fake_options)
  end
  
  def test_build
    @test_build ||= get_runner_instance
  end

  def get_runner_instance
    run_scenario "basic" do |runner|
      return runner.task_instance
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
    it "should instantiate the given class and call the run method" do
      FoobarTask.foo.nil?.should == true
      test_build.run_build_task FoobarTask
      FoobarTask.foo.should == :bar
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

  describe "#__path__" do
    it "should return the build path" do
      build = fake_build
      build.__path__.should == "#{fake_options.work_dir}/tmp/build"
    end
  end
  
  describe "#store" do
    it "should return an object that can store values" do
      build = fake_build
      store = build.store
      store.test_value.should == nil
      store.test_value = 42
      store.test_value.should == 42
    end
  end

  describe "#config" do
    it "should return an object that can be accessed by []" do
      build = fake_build
      config = build.config
      config[:test_value].should == nil
    end
  end

  describe "#dest_file" do
    it "should return the PDF's filename" do
      build = fake_build
      build.dest_file.should == "#{fake_options.work_dir}/bin/#{fake_options.contents_template}.pdf"
    end
  end
  
end
