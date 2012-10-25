module Task
  class Test < Base
    def run
      run_test :citations_given
      run_test :references_given
      run_test :unknown_abbrevs
      run_test :plenked_footnotes
      run_test :valid_sources
    end

    def run_test(sym)
      require "task/tests/#{sym}"
      klass = eval "Task::Tests::#{class_name sym}"
      klass.new(options, build).run
    end

    def class_name(sym)
      sym.to_s.split('_').map { |str| 
        str[0].upcase + str[1..-1] 
      }.join('')
    end

    def ok(msg)
      if actually_testing?
        puts "[OK]".green + " #{msg}"
      else
        # do nothing
      end
    end

    def fail(msg, &block)
      if actually_testing?
        puts "[FAILED]".red + " #{msg}"
        yield if block_given?
      else
        warning { msg }
      end
    end

    def actually_testing?
      options.task == :test
    end

  end
end
