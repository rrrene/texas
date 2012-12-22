require 'terminal-table'

module Task
  class Summary < Base
    def run
      templates = get_sorted_array_of_templates
      templates.each do |template|
        filename = template.filename.gsub(build.__path__, '')
        puts filename.dark
        puts 
        puts template.summary.gsub(/^\s*(\S)/, '    \1')
        puts
        puts
      end
    end

    def get_sorted_array_of_templates
      build.ran_templates.partition { |t| 
        t.filename.gsub(build.__path__, '') =~ /\/.+\// 
      }.reverse.map { |subarray|
        subarray.sort { |x,y| x.filename <=> y.filename }
      }.flatten
    end

  end
end
