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
  def tmp_path; build.tmp_path; end
  def build_path; build.build_path; end

  def o
    @locals
  end

  def after_write; end
  def after_render(str); str; end

  def run
    ERB.new(@content).result(binding)
  end

  def render_to_string(locals = {})
    verbose { "Rendering template #{filename.gsub(build_path, '')}" }

    build.current_template = filename
    @locals = OpenStruct.new(locals)
    output = run
    build.current_template = nil
    output
  end

  def write
    output = after_render(render_to_string)
    File.open(@output_filename, 'w') {|f| f.write(output) }
    after_write
  end
end