module Task
  module Tests
    class UnknownAbbrevs < Task::Test
      def run
        if build.left_unknown_abbrevs.empty?
          ok "Abbreviations & acronyms"
        else
          fail "Still unknown abbrevs: #{build.left_unknown_abbrevs.inspect}" 
        end
      end
    end
  end
end
