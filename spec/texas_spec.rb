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

    it "run scenario for TeX helper methods" do
      run_scenario "helper-methods-tex"
    end

    it "run scenario for .texasrc" do
      run_scenario "texasrc"
    end

    it "run scenario for lib/ helpers" do
      run_scenario "lib-helpers"
    end

    it "run scenario for rerun" do
      run_scenario "rerun"
    end

    it "run scenario for --new" do
      run_scenario "new-project"
    end

  end
end
