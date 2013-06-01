require 'zdns/packet/type'
require 'zdns/packet/class'
require 'zdns/packet/header'
require 'zdns/packet/question'
require 'zdns/buffer'

module ZDNS
  class Packet
    attr_reader :header
    attr_reader :questions
    attr_reader :answers
    attr_reader :authorities
    attr_reader :additionals

    def initialize
      @header = nil
      @questions = []
      @answers = []
      @authorities = []
      @additionals = []
    end

    def header
      @header ||= Header.new
    end

    def to_bin
      bin = header.to_bin
      bin = questions.inject(bin) {|bin,question| question.to_bin(bin)}
      [answers, authorities, additionals].each do |section|
        bin = section.inject(bin) {|bin,rr| rr.to_bin(bin)}
      end

      bin
    end

    def parse(buf)
      buf = Buffer.new(buf.to_s) unless buf.respond_to?(:read)

      # header
      @header = Header.new_from_buffer(buf)

      # questions
      @header.qdcount.times do |i|
        @questions << Question.new_from_buffer(buf)
      end

      # answers
      @header.ancount.times do |i|
        @answers << RR.new_from_buffer(buf)
      end

      # authorities
      @header.nscount.times do |i|
        @authorities << RR.new_from_buffer(buf)
      end

      # additionals
      @header.arcount.times do |i|
        @additionals << RR.new_from_buffer(buf)
      end

      self
    end

    class << self
      def new_from_buffer(buf)
        new.parse(buf)
      end
    end
  end
end
