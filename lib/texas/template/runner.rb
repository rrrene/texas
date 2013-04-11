module Texas
  module Template
    module Runner
    end
  end
end

require_relative 'runner/base'

all_rbs = Dir[ File.join( File.dirname(__FILE__), "runner", "*.rb" ) ]
all_rbs.each do |t|
  require t
end
