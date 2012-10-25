module Texas
  TEX_SUBDIR_NAME = 'tex'

  class << self
    attr_accessor :texas_dir, :verbose, :warnings
  end
end
Texas.texas_dir = File.join(File.dirname(__FILE__), '..')

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