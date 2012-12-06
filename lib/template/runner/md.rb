class Template::Runner::Markdown < Template::Runner::Base

  def postprocess(output)

    output.gsub(/^%(.+)$/, '')
  end

  def after_write
    if `which pandoc`.empty?
      puts "\nAborting build: pandoc not found in PATH"
      exit
    end
    tex_filename = @output_filename + ".tex"
    `pandoc -S #{@output_filename} -o #{tex_filename}`
  end
end

Template.handlers[/md(.erb)?$/] = Template::Runner::Markdown


