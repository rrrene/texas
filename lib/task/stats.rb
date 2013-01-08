require 'terminal-table'

module Task
  class Stats < Base
    WORDS_PER_PAGE = 250
    PERCENT_OK = 66

    def run
      rows = []

      @current_dir_word_count = 0
      @current_dir_page_count = 0
      @current_dir_pages_goal = 0
      @overall_word_count = 0
      @overall_page_count = 0
      @overall_pages_goal = 0

      templates = build.ran_templates.uniq

      templates.each do |template|
        filename = shorten_filename template.filename
        content = File.read(template.filename)
        word_count = content.downcase.scan(/\w+/).size
        pages_goal = template.info.pages_goal

        dir = File.dirname template.filename
        if @current_dir != dir
          if !@current_dir.nil?
            percent = if @current_dir_pages_goal != 0
              (@current_dir_page_count / @current_dir_pages_goal * 100).to_i
            else
              "---"
            end
            rows << :separator
            rows << [nil, colored_page_percent(@current_dir_page_count, @current_dir_pages_goal), @current_dir_page_count.to_i, @current_dir_pages_goal]
            rows << :separator
          end

          reset_current_dir dir
        end

        if filename !~ /\/contents\./
          @current_dir_word_count += word_count
          @current_dir_page_count += word_count / WORDS_PER_PAGE.to_f
          @current_dir_pages_goal += pages_goal.to_i

          @overall_word_count += word_count
          @overall_page_count += word_count / WORDS_PER_PAGE.to_f
          @overall_pages_goal += pages_goal.to_i
        end

        rows << [filename, word_count, colored_page_count(word_count, pages_goal.to_i), pages_goal]

        if template == templates.last
            
          rows << :separator
          rows << [nil, nil, @current_dir_page_count.to_i, @current_dir_pages_goal]
          rows << :separator
          rows << ["#{@overall_word_count} words", colored_page_percent(@overall_page_count, @overall_pages_goal), @overall_page_count.to_i, @overall_pages_goal]
        end
      end
      table = Terminal::Table.new :rows => rows, :headings => ['Template', 'Words', 'Pages', 'Goal']
      puts table
    end

    def colored_page_count(word_count, pages_goal)
      count = word_count / WORDS_PER_PAGE
      if pages_goal == 0
        count.to_s
      elsif count >= pages_goal
        count.to_s.green
      elsif count >= pages_goal * PERCENT_OK / 100
        count.to_s.yellow
      else
        count.to_s.red
      end
    end

    def colored_page_percent(page_count, pages_goal)
      percent = if pages_goal.to_i != 0
        (page_count / pages_goal * 100).to_i
      else
        0
      end
      str = "#{percent}%"
      if percent >= 100
        str.green
      elsif percent >= PERCENT_OK
        str.yellow
      else
        str.dark
      end
    end

    def reset_current_dir(dir)
      @current_dir_word_count = 0
      @current_dir_page_count = 0
      @current_dir_pages_goal = 0
      @current_dir = dir
    end

    def shorten_filename(f)
      b_full = File.basename(f)
      arr = b_full.split('-')
      if arr.size > 4
        b_short = arr[0..2].join('-') + '-...-' + arr[-1]
      else
        b_short = b_full
      end
      f.gsub(build.__path__, '').gsub(b_full, b_short)
    end

  end
end
