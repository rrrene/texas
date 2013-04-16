$:.unshift('lib')
require 'texas/version'

Gem::Specification.new do |s|
  s.author = "René Föhring"
  s.email = 'rf@bamaru.de'
  s.homepage = "http://github.com/rrrene/texas"

  s.name = 'texas'
  s.version = Texas::VERSION::STRING.dup
  s.platform = Gem::Platform::RUBY
  s.summary = "A tool for creating LaTex files from ERb templates."
  s.description = "A tool for creating LaTex files from ERb templates and processing them into PDF format."

  s.files = Dir[ 'lib/**/*', 'spec/**/*', 'bin/*', 'contents/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.executables  << 'texas'

  s.add_runtime_dependency 'term-ansicolor'
  s.add_runtime_dependency 'listen'
  s.add_runtime_dependency 'rb-inotify', '~> 0.8.8'
end
