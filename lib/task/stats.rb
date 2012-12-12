require 'terminal-table'

module Task
  class Stats < Base
    WORDS_PER_PAGE = 250

    def run
      rows = []
      templates = build.ran_templates.sort {|x,y| x.filename <=> y.filename }
      templates.each do |template|
        filename = template.filename.gsub(build.__path__, '')
        content = File.read(template.filename)
        word_count = content.downcase.scan(/\w+/).size
        pages_goal = template.info.pages_goal
        rows << [filename, word_count, page_count(word_count, pages_goal.to_i), pages_goal]
      end
      table = Terminal::Table.new :rows => rows, :headings => ['Template', 'Words', 'Pages', 'Goal']
      puts table
    end

    def page_count(word_count, pages_goal)
      count = word_count / WORDS_PER_PAGE
      if pages_goal == 0
        count.to_s
      elsif count >= pages_goal
        count.to_s.green
      elsif count >= pages_goal / 2
        count.to_s.yellow
      else
        count.to_s.red
      end
    end
  end
end
