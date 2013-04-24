require_relative '../helper/tex'

class Texas::Template::Runner::TeX < Texas::Template::Runner::Base
  include Texas::Template::Helper::TeX

  def after_render(output)
    output.gsub(/^%(.+)$/, '')
  end
end

Texas::Template.register_handler %w(tex tex.erb), Texas::Template::Runner::TeX
