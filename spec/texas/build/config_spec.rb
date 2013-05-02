require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Texas::Build::Config do

  def texasrc_filename
    File.join(original_test_data_dir(:texasrc), ".texasrc")
  end

  describe "#new" do
    it "takes a hash and makes it accessible via methods" do
      config = Texas::Build::Config.new({:foo => :bar})
      config.foo.should == :bar
      lambda { config.some_value }.should raise_error(NoMethodError)
    end
  end

  describe "#[]" do
    it "takes a string" do
      config = Texas::Build::Config.new({:foo => :bar})
      config["foo"].should == :bar
    end

    it "takes a symbol" do
      config = Texas::Build::Config.new({:foo => :bar})
      config[:foo].should == :bar
    end
  end

  describe "#document" do
    it "takes a hash" do
      config = Texas::Build::Config.new({:document => {:foo => :bar}})
      config.document.should_not be_nil
      config.document.foo.should == :bar
    end
    it "does not raise errors for none existing keys" do
      config = Texas::Build::Config.new({:document => {:foo => :bar}})
      config.document.some_other_value.should be_nil
    end
  end

  describe "#merge!" do
    it "deep_merges a key into the config" do
      hash = {
        :document => {:foo => :bar, :some_other_value => true}, 
        :other_mode => {:document => {:foo => 42}}
      }
      config = Texas::Build::Config.new(hash)
      config.document.should_not be_nil
      config.document.foo.should == :bar
      config.document.some_other_value.should be_true
      config.merge! "other_mode"
      config.document.foo.should == 42
      config.document.some_other_value.should be_true
    end
  end

  describe "#create" do
    it "takes a filename" do
      config = Texas::Build::Config.create({:document => {:some_value => 42}})
      config.document.should_not be_nil
      config.document.some_value.should == 42
      config.document.some_other_value.should be_nil
    end

    it "takes a filename and a merge key" do
      config = Texas::Build::Config.create({:document => {:some_value => 42}, :other_mode => {:document => {:some_value => 24, :some_other_value => 42}}}, "other_mode")
      config.document.should_not be_nil
      config.document.some_value.should == 24
      config.document.some_other_value.should be_true
    end
  end

end