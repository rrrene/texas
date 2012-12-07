require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Texas::Runner do
  describe "#initialize" do

    it "run basic tex scenario" do
      run_scenario "basic-tex"
    end

    it "run basic markdown scenario" do
      run_scenario "basic-md"
    end

    it "run scenario with different master file" do
      run_scenario "different-master-tex"
    end

  end
end
