glob = File.join( File.dirname(__FILE__), "helpers", "**.rb" )
Dir[glob].each do |filename|
  load filename
end
