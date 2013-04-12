module Texas
  module Build
    module Task
      class CopyContentsToBuildPath < Base
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
          FileUtils.cp_r contents_dir, build_path
        end

      end
    end
  end
end
