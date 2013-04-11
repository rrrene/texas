module Texas
  module Build
    module Task
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
