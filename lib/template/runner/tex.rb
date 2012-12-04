require 'template/helper/tex'

class Template::Runner::TeX < Template::Runner::Base
  include Template::Helper::TeX

  def postprocess(output)
    output.gsub(/^%(.+)$/, '')
  end
end

Template.handlers[/tex.erb$/] = Template::Runner::TeX