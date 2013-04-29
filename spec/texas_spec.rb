require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def pandoc_present?
  where = `which pandoc`
  !where.empty?
end


describe Texas::Runner do
  describe "#initialize" do

    it "run basic tex scenario" do
      run_scenario "basic-tex", %w(-d)
    end

    it "run basic tex scenario with some arguments" do
      run_scenario "basic-tex", %w(-d contents/input_template)
    end

    it "run basic tex scenario" do
      run_scenario "basic-tex"
    end

    it "run basic markdown scenario", :if => pandoc_present? do
      run_scenario "basic-md"
    end

    it "run scenario with different master file" do
      run_scenario "different-master-tex"
    end

    it "run scenario for TeX helper methods", :if => pandoc_present? do
      run_scenario "helper-methods-tex"
    end

    it "run scenario for .texasrc" do
      run_scenario "texasrc"
    end

    it "run scenario for .texasrc with --merge-config and fail" do
      lambda {
        run_scenario "texasrc", :merge_config => "other_mode"
      }.should raise_error
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
