#!/usr/bin/env ruby -wKU

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rspec'
require 'fileutils'

require 'texas'

def rebuild_test_data_dir!(scenario)
  FileUtils.rm_rf test_data_dir(scenario)
  FileUtils.mkdir_p test_data_dir(scenario)

  source_dir = original_test_data_dir(scenario)
  FileUtils.cp_r(source_dir, tmp_dir)
end

def original_test_data_dir(scenario)
  File.join(File.dirname(__FILE__), 'fixtures', scenario.to_s)
end

def test_data_dir(scenario)
  File.join(tmp_dir, scenario.to_s)
end

def tmp_dir
  File.join(File.dirname(__FILE__), '..', 'tmp')
end

def use_scenario(scenario)
  rebuild_test_data_dir! scenario
  Dir.chdir test_data_dir(scenario)
  Dir.pwd
end

def run_scenario(scenario, options = {})
  dir = use_scenario(scenario)
  Texas::Runner.new(options)
  should_templates = Dir[File.join(dir, "tmp", "build", "*.tex.should")]
  should_templates.each do |should_file|
    generated_file = should_file.gsub(/\.should$/, '')
    File.read(generated_file).should == File.read(should_file)
  end
end

RSpec.configure do |config|
  config.before(:each) {
#    rebuild_test_data_dir!
#    Dir.chdir(test_data_dir)
  }
end
