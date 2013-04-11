module Texas
  class << self
    attr_accessor :contents_subdir_name
    attr_accessor :texas_dir, :verbose, :warnings
  end
end
Texas.texas_dir = File.join(File.dirname(__FILE__), '..')
Texas.contents_subdir_name = "contents"

require 'pp'

require 'texas/option_parser'
require 'texas/build'
require 'texas/core_ext'
require 'texas/find'
require 'texas/sources'
require 'texas/task'
require 'texas/template'
require 'texas/version'
require 'texas/runner'