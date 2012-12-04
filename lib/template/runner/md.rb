class Template::Runner::Markdown < Template::Runner::Base

  def postprocess(output)

    output.gsub(/^%(.+)$/, '')
  end

  def after_write
    tex_filename = @output_filename.gsub(/\.md$/, '.tex')
    `pandoc -S #{@output_filename} -o #{tex_filename}`
  end
end

Template.handlers[/md$/] = Template::Runner::Markdown


