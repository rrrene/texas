module Task
end

require 'task/base'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "task", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
