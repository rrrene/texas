module Template
  class << self
    attr_accessor :handlers

    def handler(filename)
      Template.handlers.each do |pattern, klass|
        return klass if filename =~ pattern
      end
      warning "No template handler found for: #{filename}"
      Template::Runner::Base
    end

    def create(filename, build)
      handler(filename).new(filename, build)
    end
  end
end

Template.handlers = {}

require 'template/helper'
require 'template/runner'
