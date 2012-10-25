module Sources
  class Entry
    attr_accessor :__key__, :errors

    def initialize(key, hash)
      self.__key__ = key
      self.errors = []
      @attr = hash
    end
    
    FIELDS = [:authors, :title, :in_compilation, :edition, :place, :year]
    FIELDS.each do |name|
      define_method name do
        @attr[name.to_s] || (raise "Not found mandatory field #{name.inspect} for Sources::Entry #{__key__.inspect}")
      end
      define_method "#{name}?" do
        !!@attr[name.to_s]
      end
    end

    def [](key)
      value = @attr[key.to_s]
      if !value && methods.include?(key.to_sym)
        value = method(key.to_sym).call
      end
      value
    end

    def label(include_year = true)
      str = @attr['label']
      str ||= author_enumeration
      if include_year
        "#{str} (#{self[:year]})"
      else
        str
      end
    end

    def invalid?
      !valid?
    end

    def valid?
      if !year? then errors << "No year given." end
      if !in_compilation?
        # if !edition? then errors << "Edition missing." end
      end
      errors.empty?
    end

    private

    def author_enumeration(et_al_limit = 3)
      names = self[:authors].map { |name| name.gsub(/(\,.+)/, '') }
      if names.size > et_al_limit
        "#{names.first} et al."
      else
        names.join('/')
      end
    end

  end
end