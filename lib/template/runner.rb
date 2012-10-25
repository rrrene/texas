module Template
  class Runner
    attr_accessor :build, :filename
    include Helper

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

    def run(locals = {})
      verbose { "Running template #{filename.gsub(build_path, '')}" }

      build.current_template = filename
      @locals = locals
      output = ERB.new(@content).result(binding)
      build.current_template = nil
      output
    end

    def write
      output = run
      output = output.gsub(/^%(.+)$/, '')
      File.open(@output_filename, 'w') {|f| f.write(output) }
    end
  end
end
