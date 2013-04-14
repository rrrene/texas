module Texas
  module Task
    class New < Base
      def source_dir
        File.join(Texas.texas_dir, "spec", "fixtures", "new-project")
      end

      def dest_dir
        File.join(Dir.pwd, options.new_project_name)
      end

      def run
        if File.exists?(dest_dir)
          if Dir[File.join(dest_dir, "*")].empty?
            FileUtils.rm_r dest_dir
          else
            warn "texas: directory is not empty: #{dest_dir}"
            exit 1
          end
        end
        FileUtils.cp_r source_dir, dest_dir
      end
    end
  end
end
