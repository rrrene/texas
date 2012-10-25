# encoding: UTF-8
module Find
  # Finds abbreviations like
  #   ["bspw.", "bzgl.", "d.h.", "ff.", "o.S.", "o.V.", "u.a.", "z.B."]
  class Abbreviations < Base
    def find_in_content(content)
      arr = []
      arr << content.scan(/[^a-zA-Zäöü]([a-zA-Zäöü]{1,2}\.\s*[a-zA-Zäöü]{1,2}\.)[^a-zA-Zäöü]/)
      arr << content.scan(/([a-zA-Zäöü]{1,6}\.)[\ ,][a-z]/)
      arr.flatten.uniq.reject { |word| word =~ /\d/ }
    end
  end
end
