module Build
end

require 'build/tracker'
require 'build/base'
require 'build/dry'
require 'build/final'

require 'build/task/base'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "build", "task", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
