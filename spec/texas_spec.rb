require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Texas::Runner do
  describe "#initialize" do

    it "run basic scenario" do
      run_scenario :basic
    end

  end
end
