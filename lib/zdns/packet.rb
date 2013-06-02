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

    def dig_dump
      flags = [:qr, :aa, :tc, :rd, :ra].select{|k| 0<header.send(k).to_i}.join(" ")
      qdcount = questions.length
      ancount = answers.length
      nscount = authorities.length
      arcount = additionals.length

      # header
      dump = <<EOF
; <<>> ZDNS #{ZDNS::VERSION} <<>> #{questions.map{|q| q.name}.join(" ")}
;; Got Answer:
;; ->>HEADER<<- opcode: #{header.opcode.to_s}, status: #{header.rcode.to_s}, id: #{header.id.to_i}
;; flags: #{flags}; QUERY: #{qdcount}, ANSWER: #{ancount}, AUTHORITY: #{nscount}, ADDITIONAL: #{arcount}
EOF

      # question
      if 0<qdcount
        dump += "\n"
        dump += ";; QUESTION SECTION:\n"
        questions.each do |question|
          dump += sprintf("%s\t\t\t%s\t%s\n", question.name, question.cls.to_s, question.type.to_s)
        end
      end

      # answer
      # authority
      # additional
      [["ANSWER", answers], ["AUTHORITY", authorities], ["ADDITIONAL", additionals]].each do |label, rrs|
        if 0<rrs.length
          dump += "\n"
          dump += ";; #{label} SECTION:\n"
          rrs.each do |rr|
            dump += sprintf("%s\t\t%i\t%s\t%s\n", rr.name, rr.ttl, rr.cls.to_s, rr.type.to_s)
          end
        end
      end

      dump
    end

    def parse(buf)
      buf = Buffer.new(buf.to_s) unless buf.respond_to?(:read)

      # header
      @header = Header.new_from_buffer(buf)
p header

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
