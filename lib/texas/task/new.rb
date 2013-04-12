module Texas
  module Task
    class New < Base

      def source_dir
        File.join(Texas.texas_dir, "spec", "fixtures", "new")
      end

      def dest_dir
        File.join(Dir.pwd, options.new_project_name)
      end

      def run
        FileUtils.cp_r source_dir, dest_dir
      end
    end
  end
end
