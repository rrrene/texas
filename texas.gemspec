$:.unshift('lib')
require 'texas'

Gem::Specification.new do |s|
  s.author = "René Föhring"
  s.email = 'rf@bamaru.de'
  s.homepage = "http://github.com/rrrene/texas"

  s.name = 'texas'
  s.version = Texas::VERSION::STRING.dup
  s.platform = Gem::Platform::RUBY
  s.summary = "A tool for creating LaTex files from ERb templates."
  s.description = "A tool for creating LaTex files from ERb templates and processing them into PDF format."

  s.files = Dir[ 'lib/**/*', 'spec/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.executables << 'texas'

end
