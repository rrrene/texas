require 'template/helper/base'
require 'template/helper/info'

class Template::Runner::Base
  include Template::Helper::Base
  include Template::Helper::Info

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
    build.document_struct
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
  end

  def __run__(locals = {})
    verbose { "[T] #{filename.gsub(build_path, '')}".dark }

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