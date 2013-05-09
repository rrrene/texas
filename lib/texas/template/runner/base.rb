require_relative '../helper/base'
require_relative '../helper/info'
require 'erb'

module Texas
  # Runs and renders a template.
  #
  class Template::Runner::Base
    include Texas::OutputHelper
    include Texas::Template::Helper::Base
    include Texas::Template::Helper::Info

    # Returns the build object
    attr_accessor :build

    # Returns the original content of the template
    attr_accessor :content

    # Returns the location of the template (in the build directory)
    attr_accessor :filename

    def initialize(_filename, _build)
      self.filename = _filename
      self.build = _build
      self.content = File.read(filename)
      @output_filename = filename.gsub(/(\.erb)$/, '')
    end

    # Shorthand to the build's root.
    #
    # TODO: Is this used?
    def root
      build.root
    end

    # Shorthand to the build's __path__.
    #
    def build_path
      build.__path__
    end

    # Returns this template's path.
    #
    def __path__
      File.dirname filename
    end
    
    # Shorthand to the build's config's document object.
    # Can be used inside templates to display config information.
    #
    # Example: 
    #   <%= document.title %>
    #
    def document
      build.config.document
    end

    # Shorthand to the build's store object.
    # Can be used inside templates to store information.
    #
    def store
      build.store
    end

    # Shorthand to the template's locals object.
    # Can be used inside templates.
    #
    # Example:
    #   # some_template.tex.erb
    #
    #   Value: <%= o.some_value %>
    #
    #   # contents.tex.erb
    #
    #   <%= render :some_template, :some_value => 42
    #
    #   # => "Value: 42"
    def o
      @locals
    end

    def append_to_output(str)
      @erbout << str
    end

    # Renders the template into a String.
    #
    def __render__(locals = {})
      @locals = OpenStruct.new(locals)
      ERB.new(@content, nil, nil, "@erbout").result(binding)
    rescue TemplateError => ex
      raise ex
    rescue StandardError => ex
      raise TemplateError.new(self, ex.message, ex)
    end

    # Runs the template with the given local variables.
    #
    def __run__(locals = {})
      verbose { TraceInfo.new(:template, filename.gsub(build_path, ''), :dark) }

      old_current_template = build.current_template
      build.current_template = self
      @output = after_render __render__(locals)
      build.current_template = old_current_template
      @output
    end

    # Called after write.
    #
    def after_write
    end

    # Called after __render__.
    # Can be overriden to modify the rendered contents of the template.
    #
    def after_render(str)
      str
    end

    # Runs the template and writes it to disk afterwards.
    #
    def write
      __run__
      File.open(@output_filename, 'w') {|f| f.write(@output) }
      after_write
    end
  end
end