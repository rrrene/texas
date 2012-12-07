require 'template/helper/md'

class Template::Runner::Markdown < Template::Runner::Base
  include Template::Helper::Markdown

  def postprocess(output)
    output.gsub(/^%(.+)$/, '')
  end

  def after_write
    if `which pandoc`.empty?
      puts "\nAborting build: pandoc not found in PATH (required for Markdown rendering)"
      exit
    end
    tex_filename = Template.basename(@output_filename) + ".tex"
    `pandoc -S #{@output_filename} -o #{tex_filename}`
  end
end

Template.register_handler %w(md md.erb), Template::Runner::Markdown
