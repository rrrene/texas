require 'template/helper/tex'

class Template::Runner::TeX < Template::Runner::Base
  include Template::Helper::TeX

  def after_render(output)
    output.gsub(/^%(.+)$/, '')
  end
end

Template.register_handler %w(tex tex.erb), Template::Runner::TeX
