require 'zdns/packet/utils'

module ZDNS
  class Packet
    class Question
      include Utils

      attr_accessor :name
      attr_accessor :type
      attr_accessor :cls

      def initialize(name, type, cls)
        @name = name
        @type = type
        @cls = cls
      end

      def to_bin(result)
        name_bin = compress_domain(result, self.name)

        result + name_bin + [self.type.to_i, self.cls.to_i].pack("n2")
      end

      class << self
        def new_from_buffer(buf)
          # name
          name = buf.read_name

          # type
          type = buf.read_type

          # class
          cls = buf.read_class

          new(name, type, cls)
        end
      end
    end
  end
end
