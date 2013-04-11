module Texas
  module Build
  end
end

require_relative 'build/base'
require_relative 'build/dry'
require_relative 'build/final'

require_relative 'build/task/base'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "build", "task", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
