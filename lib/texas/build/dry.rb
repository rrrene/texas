module Texas
  module Build
    class Dry < Base
      before_task :RunBeforeScripts

      basic_task :CopyTemplatesToBuildPath, :RunMasterTemplate

      after_task :RewriteMarkedTemplates
    end
  end
end
