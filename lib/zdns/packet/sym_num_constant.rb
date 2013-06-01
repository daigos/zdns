module ZDNS
  module SymNumConstant
    def initialize(sym, num)
      @sym = sym.to_sym
      @num = num.to_i
    end

    def to_s
      @sym.to_s
    end

    def to_sym
      @sym
    end

    def to_i
      @num
    end

    # ClassMethods

    module ClassMethods
      def sym_num_const_init
        @sym_hash = {}
        @num_hash = {}
      end

      def regist(sym, num)
        obj = new(sym, num)

        @sym_hash[obj.to_sym] = obj
        @num_hash[obj.to_i] = obj

        obj
      end

      def from_sym(sym)
        @sym_hash[sym.to_sym]
      end

      def from_num(num)
        @num_hash[num.to_i] || new(nil, num.to_i)
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
      klass.sym_num_const_init
    end

  end
end
