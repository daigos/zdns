require 'socket'

module ZDNS
  class Client
    attr_reader :server
    attr_reader :port

    def initialize(server="8.8.8.8", port=53)
      @server = server
      @port = port
    end

    def lookup(name, type, cls)
      req_packet = Packet.new
      req_packet.questions << Packet::Question.new(name, type, cls)
      req_packet.header.query!
      req_packet.header.qdcount = 1
      req_packet_bin = req_packet.to_bin

      # udp
      udp_socket = UDPSocket.new
      udp_socket.connect(@server, @port)
      udp_socket.send(req_packet_bin, 0)
      res_packet_bin, address = udp_socket.recvfrom(1024)
      res_packet = Packet.new_from_buffer(res_packet_bin)

      # tcp
      if 0<res_packet.header.tc.to_i
        tcp_socket = TCPSocket.new(@server, @port)
        tcp_socket.send([req_packet_bin.length].pack("n") + req_packet_bin, 0)
        len = tcp_socket.read(2).unpack("n")[0]
        res_packet_bin = tcp_socket.read(len)
        res_packet = Packet.new_from_buffer(res_packet_bin)
      end

      res_packet
    end
  end
end
