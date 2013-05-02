module Texas
  module Build
  end
end

require_relative 'build/config'
require_relative 'build/config_loader'
require_relative 'build/base'
require_relative 'build/dry'
require_relative 'build/final'

require_relative 'build/task/base'
require_relative 'build/task/script'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "build", "task", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
