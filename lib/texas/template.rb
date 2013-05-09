module Texas
  module Template
    class << self
      # Returns a map of file extensions to handlers
      attr_accessor :handlers

      # Returns all known template extensions
      attr_accessor :known_extensions

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

      # Registers the methods defined in a module to use
      # them in templates.
      #
      # Example:
      #   module Foo
      #     def bar; "foobar"; end
      #   end
      #   Template.register_helper Foo
      #
      #   # afterwards, this prints "foobar" in any template:
      #   <%= bar %>
      #
      def register_helper(klass)
        Template::Runner::Base.__send__ :include, klass
      end

      # Returns a Template runner for the given filename
      #
      # Example:
      #   Template.create("some_file.tex.erb", build)
      #   # => #<Texas::Template::Runner::TeX ...>
      #
      def create(filename, build)
        handler(filename).new(filename, build)
      end

      # Returns the filename without the template extension
      #
      # Example:
      #   Template.basename("/home/rene/github/sample_project/tmp/build/chapter-01/contents.md.erb")
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
