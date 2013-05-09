module Texas
  module Build
    module Task
      # This build task finds and runs the master template.
      #
      class RunMasterTemplate < Base

        def find_master_template(possible_templates)
          regexes = Template.handlers.keys
          valid_master_templates = possible_templates.select do |f| 
            regexes.any? { |regex| f =~ regex }
          end
          valid_master_templates.first
        end

        def run
          filename = find_master_template Dir[build.master_file+'*']
          master_template = Template.create(filename, build)
          master_template.write
        end

      end
    end
  end
end
