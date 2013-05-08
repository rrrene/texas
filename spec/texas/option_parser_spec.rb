require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Texas::OptionParser do
  describe "#initialize" do
    it "takes an array" do
      op = Texas::OptionParser.new(%w(-d))
    end
  end

  describe "#parse" do
    it "should abort if check_mandatory fails" do
      op = Texas::OptionParser.new(%w(-d))
      lambda { op.parse }.should raise_error SystemExit
    end

    it "should identify the right contents_dir and contents_template options" do
      use_scenario "basic-tex"

      options = Texas::OptionParser.new(%w()).parse
      options.contents_dir.should == "contents"
      options.contents_template.should == "contents"

      options = Texas::OptionParser.new(%w(contents/input_template)).parse
      options.contents_dir.should == "contents"
      options.contents_template.should == "input_template"

      options = Texas::OptionParser.new(%w(contents/sub_dir/unused_template)).parse
      options.contents_dir.should == "contents"
      options.contents_template.should == "sub_dir/unused_template"
    end
  end

  describe ".parse_additional_options" do
    it "should take a block" do
      Texas::OptionParser.parse_additional_options do |parser, options|
        options.check_mandatory_arguments = false
        options.foo = true
        parser.on("--[no-]foo", "Switch foo") do |v|
          options.foo = v
        end
      end
      op = Texas::OptionParser.new(%w())
      options = op.parse
      options.foo.should be_true
      op = Texas::OptionParser.new(%w(--foo))
      options = op.parse
      options.foo.should be_true
      op = Texas::OptionParser.new(%w(--no-foo))
      options = op.parse
      options.foo.should be_false
    end
  end
end
