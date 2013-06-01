require 'socket'
require 'thread'
require 'logger'

module ZDNS
  class Server
    attr_reader :host
    attr_reader :port
    attr_accessor :logger

    def initialize(host="0.0.0.0", port=53)
      @host = host
      @port = port.to_i
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def run
      stop

      @socket = UDPSocket.new
      @socket.bind(host, port)

      loop do
         packet, address = @socket.recvfrom(1024)
         Thread.new {
           begin
             service(packet, address)
           rescue => e
             logger.error(e)
           end
         }
      end
    end

    def stop
      if @socket
        @socket.close
        @socket = nil
      end
    end

    def service(packet, address)
      address_family, port, host, address = address

      logger.info("request from: #{host}:#{port}")

      packet = Packet.new_from_buffer(packet)

      if packet.header.query?
        begin
          # lookup
          packet.questions.each do |question|
            # answers
            lookup_answers(question).each do |answer|
              packet.answers << answer
            end

            # authorities additionals
            lookup_authorities(question).each do |rrs|
              packet.authorities << rrs
            end
          end

          # header
          if 0<packet.answers.length || 0<packet.authorities.length
            packet.header.flag_aa = Packet::Header::AA::AUTHORITATIVE_ANSWER
            packet.header.flag_rcode = Packet::Header::Rcode::NO_ERROR
          else
            packet.header.flag_rcode = Packet::Header::Rcode::NAME_ERROR
          end

        rescue => e
          logger.error(e)
          packet.header.flag_rcode = Packet::Header::Rcode::SERVER_FAILURE

        ensure
          # header
          packet.header.response!
          packet.header.flag_ra = Packet::Header::RA::RECURSION
          packet.header.qdcount = packet.questions.length
          packet.header.ancount = packet.answers.length
          packet.header.nscount = packet.authorities.length
          packet.header.arcount = packet.additionals.length
        end

        # send
        @socket.send(packet.to_bin, 0, host, port)
      end
    end

    def lookup_answers(question)
      []
    end

    def lookup_authorities(question)
      []
    end
  end
end
