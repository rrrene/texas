module Texas
  class << self
    # Returns the name of the template sub directory
    # defaults to "contents"
    attr_accessor :contents_subdir_name

    # Points to the directory where Texas is located
    attr_accessor :texas_dir

    # Returns true if Texas is run in verbose mode
    attr_accessor :verbose

    # Returns true if warnings are enabled
    attr_accessor :warnings
  end
end
Texas.texas_dir = File.join(File.dirname(__FILE__), '..')
Texas.contents_subdir_name = "contents"

require 'pp'

require_relative 'texas/output_helper'
require_relative 'texas/option_parser'
require_relative 'texas/build'
require_relative 'texas/core_ext'
require_relative 'texas/task'
require_relative 'texas/template'
require_relative 'texas/version'
require_relative 'texas/runner'