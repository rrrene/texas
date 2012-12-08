require 'template/helper/base'

class Template::Runner::Base
  include Template::Helper::Base

  attr_accessor :build, :filename

  def initialize(_filename, _build)
    self.filename = _filename
    self.build = _build
    @output_filename = filename.gsub(/(\.erb)$/, '')
    @content = File.read(filename)
  end

  # TODO: Use Forwardable
  def root; build.root; end
  
  def build_path
    build.__path__
  end

  def __path__
    File.dirname filename
  end

  def o
    @locals
  end

  def __render__(locals = {})
    @locals = OpenStruct.new(locals)
    ERB.new(@content).result(binding)
  end

  def __run__(locals = {})
    verbose { "+ #{filename.gsub(build_path, '')}".dark }

    old_current_template = build.current_template
    build.current_template = filename
    output = __render__(locals)
    build.current_template = old_current_template
    output
  end


  def after_write; end
  def after_render(str); str; end

  def write
    output = __run__
    output = after_render(output)
    File.open(@output_filename, 'w') {|f| f.write(output) }
    after_write
  end
end