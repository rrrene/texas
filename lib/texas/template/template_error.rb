class TemplateError < StandardError
  attr_accessor :original, :template

  def initialize(template, message, original = nil)
    super(message)
    self.template = template
    self.original = original
  end

  def filename
    template.filename.gsub(template.build_path, '')
  end

  def parse_backtrace_for_origin
    arr = original ? original.backtrace : backtrace
    arr.each_with_index do |line, index| 
      if line =~ /\(erb\):(\d+)/ 
        @line_number = $1.to_i
        line_before = backtrace[index-1]
        @method_name = line_before =~ /\d+:in\s+`([^\)]+)'/ && $1
        return
      end
    end
  end

  def origin
    parse_backtrace_for_origin
    "#{filename}:#{@line_number}:in `#{@method_name}'"
  end

  def message
    super + "\n#{origin}".cyan
  end
end