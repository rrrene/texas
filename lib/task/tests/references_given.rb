module Task
  module Tests
    class ReferencesGiven < Task::Test
      def run
        check :figures
      end

      def check(namespace)
        references = track.send("__#{namespace.to_s.gsub(/s$/, '')}_references__").map(&:last).map(&:first)
        not_referenced = track.send("__#{namespace}__").select { |a| 
          info = a.last
          ref = reference_name(namespace, info[0])
          !references.include?(ref)
        }
        if not_referenced.empty?
          ok "All references given"
        else
          fail "Not all references given." do
            not_referenced.each do |(template, info)|
              puts "#" + " " + template.to_s.gsub(build.root, '').cyan
              puts "#" + "   #{info}"
            end
          end
        end
      end

      def reference_name(namespace, ref)
        map = {:figures => "fig"}
        prefix = map[namespace]
        suffix = ref.gsub('/', ':')
        "#{prefix}:#{suffix}"
      end

    end
  end
end
