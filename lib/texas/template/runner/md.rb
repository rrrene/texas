require_relative '../helper/md'

class Texas::Template::Runner::Markdown < Texas::Template::Runner::Base
  include Texas::Template::Helper::Markdown

  def after_write
    if `which pandoc`.empty?
      trace "\nAborting build: pandoc not found in PATH (required for Markdown rendering)"
      exit
    end
    tex_filename = Texas::Template.basename(@output_filename) + ".tex"
    `pandoc -S "#{@output_filename}" -o "#{tex_filename}"`
  end
end

Texas::Template.register_handler %w(md md.erb), Texas::Template::Runner::Markdown
