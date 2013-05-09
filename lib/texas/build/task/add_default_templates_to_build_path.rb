module Texas
  module Build
    module Task
      # This build task copies those templates from Texas' own template 
      # directory that are still missing in the current project's build 
      # directory (e.g. the preambel partial)
      #
      class AddDefaultTemplatesToBuildPath < Base
        def build_path
          build.__path__
        end

        def run
          glob = File.join(Texas.texas_dir, Texas.contents_subdir_name, '*.*')
          Dir[glob].each do |filename|
            dest = File.join(build_path, File.basename(filename))
            unless File.exists?(dest)
              FileUtils.cp filename, build_path
            end
          end
        end

      end
    end
  end
end
