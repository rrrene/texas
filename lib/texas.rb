module Texas
  class << self
    attr_accessor :contents_subdir_name
    attr_accessor :texas_dir, :verbose, :warnings
  end
end
Texas.texas_dir = File.join(File.dirname(__FILE__), '..')
Texas.contents_subdir_name = "tex"

require 'pp'
require 'option_parser'

require 'build'
require 'core_ext'
require 'find'
require 'sources'
require 'task'
require 'template'
require 'version'
require 'runner'