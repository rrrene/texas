module Texas
  module Build
    class Dry < Base
      before_task :ExecuteBeforeScripts, :CopyContentsToBuildPath

      basic_task :AddDefaultTemplatesToBuildPath, :RunMasterTemplate

      after_task :RewriteMarkedTemplates
    end
  end
end
