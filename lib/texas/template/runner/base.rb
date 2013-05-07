require_relative '../helper/base'
require_relative '../helper/info'
require 'erb'

module Texas
  class Template::Runner::Base
    include Texas::OutputHelper
    include Texas::Template::Helper::Base
    include Texas::Template::Helper::Info

    attr_accessor :build, :content, :filename

    def initialize(_filename, _build)
      self.filename = _filename
      self.build = _build
      self.content = File.read(filename)
      @output_filename = filename.gsub(/(\.erb)$/, '')
    end

    # TODO: Use Forwardable
    def root; build.root; end

    def build_path
      build.__path__
    end

    def __path__
      File.dirname filename
    end
    
    def document
      build.config.document
    end

    def store
      build.store
    end

    def o
      @locals
    end

    def append_to_output(str)
      @erbout << str
    end

    def __render__(locals = {})
      @locals = OpenStruct.new(locals)
      ERB.new(@content, nil, nil, "@erbout").result(binding)
    rescue TemplateError => ex
      raise ex
    rescue Exception => ex
      raise TemplateError.new(self, ex.message, ex)
    end

    def __run__(locals = {})
      verbose { TraceInfo.new(:template, filename.gsub(build_path, ''), :dark) }

      old_current_template = build.current_template
      build.current_template = self
      @output = after_render __render__(locals)
      build.current_template = old_current_template
      @output
    end

    def after_write; end
    def after_render(str); str; end

    def write
      __run__
      File.open(@output_filename, 'w') {|f| f.write(@output) }
      after_write
    end
  end
end