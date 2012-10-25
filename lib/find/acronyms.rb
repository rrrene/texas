# encoding: UTF-8
module Find
  # Finds acronyms like
  #   ["CODE24", "HTML", "LKW", "OS", "URL", "WWW"]
  class Acronyms < Base
    def find_in_content(content)
      arr = content.scan(/([a-zA-Z0-9]{2,})/).flatten
      arr.uniq.select { |word| word =~ /[A-Z].*[A-Z]/ }
    end
  end
end
