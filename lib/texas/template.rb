module Texas
  module Template
    class << self
      attr_accessor :handlers, :known_extensions

      # Returns a template handler for the given filename
      #
      # Example:
      #   Template.handler("some_file.tex.erb")
      #   # => Template::Runner::TeX
      #
      def handler(filename)
        Template.handlers.each do |pattern, klass|
          return klass if filename =~ pattern
        end
        warning { "No template handler found for: #{filename}" }
        Template::Runner::Base
      end

      # Registers a handler for the given template extensions
      #
      # Example:
      #   Template.register_handler %w(tex tex.erb), Template::Runner::TeX
      #
      def register_handler(extensions, handler_class)
        extensions.each do |ext|
          handlers[/\.#{ext}$/i] = handler_class
        end
        known_extensions.concat extensions
      end

      def register_helper(klass)
        Template::Runner::Base.__send__ :include, klass
      end

      def create(filename, build)
        handler(filename).new(filename, build)
      end

      # Returns the filename without the template extension
      #
      # Example:
      #   input_path("/home/rene/github/sample_project/tmp/build/chapter-01/contents.md.erb")
      #   # => "/home/rene/github/sample_project/tmp/build/chapter-01/contents"
      #
      def basename(filename)
        value = filename
        known_extensions.each do |str|
          value = value.gsub(/\.#{str}$/, '')
        end
        value
      end

    end
  end
end

Texas::Template.handlers = {}
Texas::Template.known_extensions = []

require_relative 'template/helper'
require_relative 'template/runner'
require_relative 'template/template_error'
