# encoding: UTF-8

module Texas
  module Find
    class Base
      def initialize(files)
        @collection = []
        files.each do |filename|
          find_in_file filename
        end
      end

      def find_in_file(filename)
        @collection << find_in_content(File.read(filename))
      end

      def to_a
        @collection.flatten.uniq.sort
      end
    end
  end
end
