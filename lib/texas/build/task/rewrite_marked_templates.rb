module Texas
  module Build
    module Task
      class RewriteMarkedTemplates < Base
        def run
          build.ran_templates.select { |t| t.marked_for_rewrite? }.each do |t|
            t.write
          end
        end
      end
    end
  end
end
