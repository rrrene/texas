module Texas
  class << self
    attr_accessor :contents_subdir_name, :texas_dir
    attr_accessor :verbose, :warnings
  end
end
Texas.texas_dir = File.join(File.dirname(__FILE__), '..')
Texas.contents_subdir_name = "contents"

require 'pp'

require_relative 'texas/option_parser'
require_relative 'texas/build'
require_relative 'texas/core_ext'
require_relative 'texas/task'
require_relative 'texas/template'
require_relative 'texas/version'
require_relative 'texas/runner'