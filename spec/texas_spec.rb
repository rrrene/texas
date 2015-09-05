require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def pandoc_present?
  where = `which pandoc`
  !where.empty?
end

describe Texas::CLI::Runner do
  describe "#initialize" do

    it "run basic tex scenario" do
      run_scenario "basic-tex"
    end

    it "run basic tex scenario with some arguments" do
      run_scenario "basic-tex", %w(-d -v)
    end

    it "run basic tex scenario with another contents_template" do
      run_scenario "basic-tex", %w(-d contents/input_template)
    end

    it "run basic tex scenario with another subdir contents_template" do
      run_scenario "basic-tex", %w(-d contents/sub_dir/unused_template)
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
      run_scenario "texasrc" do |runner|
        build = runner.task_instance
        config = build.config
        lambda {
          config.some_other_value_from_parent_dir_config.should be_true
        }.should raise_error
      end
    end

    it "run scenario for .texasrc with a parent .texasrc" do
      other_config_file = File.join(test_data_dir(""), ".texasrc")
      FileUtils.cp File.join(test_data_dir("texasrc"), ".other.texasrc"), other_config_file
      run_scenario "texasrc" do |runner|
        FileUtils.rm other_config_file # remove parent .texasrc
        build = runner.task_instance
        config = build.config
        config.document.some_other_value_from_parent_dir_config.should be_true
      end
    end

    it "run scenario for .texasrc with --merge-config and fail" do
      lambda {
        run_scenario "texasrc", :merge_config => "other_mode"
      }.should raise_error
    end

    it "run scenario for error-pdflatex and fail" do
      lambda {
        run_scenario "error-pdflatex"
      }.should raise_error
    end

    it "run scenario for error-template-not-found and fail" do
      lambda {
        run_scenario "error-template-not-found"
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
