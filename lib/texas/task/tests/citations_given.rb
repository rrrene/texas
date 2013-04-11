module Texas
  module Task
    module Tests
      class CitationsGiven < Task::Test
        def run
          if track.citations.map(&:first).include?(missing_key) 
            fail "Not all citations given." do
              run_citations_task
            end
          else
            ok "All citations given"
          end
        end

        def missing_key
          "fehlt"
        end

        def run_citations_task
          opts = OpenStruct.new(:task => :citations, :citation_author => missing_key)
          Task::Citations.new(opts, build).run
        end
      end
    end
  end
end
