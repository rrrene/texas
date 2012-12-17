require 'terminal-table'

module Task
  class Summary < Base
    def run
      templates = build.ran_templates.sort {|x,y| x.filename <=> y.filename }
      templates.each do |template|
        filename = template.filename.gsub(build.__path__, '')
        puts filename.dark
        puts 
        puts template.summary.gsub(/^\s*(\S)/, '    \1')
        puts
        puts
      end
    end

  end
end
