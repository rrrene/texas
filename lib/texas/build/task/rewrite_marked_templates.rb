module Texas
  module Build
    module Task
      class RewriteMarkedTemplates < Base
        def run
          templates.each { |t| t.write }
        end

        def templates
          build.ran_templates.uniq.select { |t| t.marked_for_rewrite? }
        end
      end
    end
  end
end
