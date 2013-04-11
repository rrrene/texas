require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Texas::Template::Runner::Base do

  def test_template(_runner)
    build = _runner.task_instance
    template_filename = File.join(build.__path__, "contents.tex.erb")
    Texas::Template.create( template_filename, build )
  end

  describe "#__path__" do
    it "should return the absolute path of the given template" do
      run_scenario "basic" do |runner|
        build = runner.task_instance
        template = test_template(runner)
        template.__path__.should == build.__path__
      end
    end
  end
  
  describe "#find_template_file" do
    it "should return the absolute path of found image" do
      run_scenario "basic" do |runner|
        build = runner.task_instance
        work_dir = build.root
        template = test_template(runner)

        found_location = template.find_template_file(["figures", "test_figure"], [:pdf, :png])
        image_file_location = File.join(work_dir, "figures", "test_figure.png")
        found_location.should == image_file_location
      end
    end
  end

end
