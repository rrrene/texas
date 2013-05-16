class TemplateError < StandardError
  attr_accessor :original, :template

  def initialize(template, message, original = nil)
    super(message)
    self.template = template
    self.original = original
    parse_backtrace_for_origin
  end

  def __backtrace__
    original ? original.backtrace : backtrace
  end

  def filename
    template.filename.gsub(template.build_path, '')
  end

  def parse_backtrace_for_origin
    arr = __backtrace__ || []
    arr.each_with_index do |line, index| 
      if line =~ /\(erb\):(\d+)/ 
        @pre_erb_backtrace = arr[0...index]
        @line_number = $1.to_i
        line_before = arr[index-1]
        @method_name = line_before =~ /\d+:in\s+`([^\)]+)'/ && $1
        return
      end
    end
  end

  def origin
    "#{filename}:#{@line_number}"
  end

  def pre_erb_backtrace
    if @pre_erb_backtrace
      arr = @pre_erb_backtrace.map do |line| 
        line.gsub(template.build.root, '.')
      end
      str = arr.empty? ? "" : arr.join("\n").dark + "\n"
    end
  end

  def message
    super + "\n#{pre_erb_backtrace}#{origin.cyan}"
  end
end