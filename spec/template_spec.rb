require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Template::Runner do
  describe ".basename" do

    it "returns the path without the known extensions" do
      Template.basename("some_path/some_file.tex.erb").should == "some_path/some_file"
    end

  end
end
