module Task
  module Tests
    class UnknownAbbrevs < Task::Test
      def run
        return # TODO: read stored left_unknown_abbrevs from store (when store exists)
        left = build.left_unknown_abbrevs
        if !left.nil? && left.empty?
          ok "Abbreviations & acronyms"
        else
          fail "Still unknown abbrevs: #{build.left_unknown_abbrevs.inspect}" 
        end
      end
    end
  end
end
