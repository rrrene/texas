module Texas
  module Task
    module Tests
      class ValidSources < Task::Test
        def run
          invalid = bib.select(&:invalid?)
          if invalid.empty?
            ok "Valid sources"
          else
            fail "Invalid sources" do
              puts "#".red
              invalid.each do |source|
                puts "#".red + "   " + source.__key__.ljust(20) + " (#{source.errors.join(' ')})"
              end
              puts "#".red
            end
          end
        end

        def bib
          build.bibliography
        end
      end
    end
  end
end
