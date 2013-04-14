glob = File.join( File.dirname(__FILE__), "helpers", "**.rb" )
Dir[glob].each do |filename|
  require filename
end
