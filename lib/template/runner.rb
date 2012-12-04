module Template
  module Runner
  end
end

require 'template/runner/base'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "runner", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
