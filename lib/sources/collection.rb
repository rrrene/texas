module Sources
  class Collection
    attr_reader :build

    def initialize(hash)
      @bib = {}
      hash ||= {}
      hash.map do |key, value|
        @bib[key] = Sources::Entry.new(key, value)
      end
    end

    def [](key)
      @bib[key.to_s] || (raise "Not found in Sources::Collection#[]: #{key.inspect}")
    end
  end
end