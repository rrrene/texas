module Build
  module Task
    class CopyTemplates < Base
      def run
        ensure_build_path_exists
        copy_to_build_path
      end

      def build_path
        build.__path__
      end

      def contents_dir
        build.contents_dir
      end

      def ensure_build_path_exists
        FileUtils.mkdir_p build_path
        rescue
      end

      def copy_to_build_path
        FileUtils.rm_r build_path
        File.join(Texas.texas_dir, Texas.contents_subdir_name)
        FileUtils.cp_r contents_dir, build_path
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
