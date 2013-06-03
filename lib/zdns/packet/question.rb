module ZDNS
  class Packet
    class Question
      attr_accessor :name
      attr_accessor :type
      attr_accessor :cls

      def initialize(name, type, cls)
        @name = name
        @type = type
        @cls = cls
      end

      def to_bin(buf)
        buf.write_domain(self.name)
        buf.write_short(self.type.to_i)
        buf.write_short(self.cls.to_i)
      end

      class << self
        def new_from_buffer(buf)
          # name
          name = buf.read_domain

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
