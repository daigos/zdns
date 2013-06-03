#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

class ZDNSServer < ZDNS::Server
  def lookup_answers(question)
    [ZDNS::Packet::RR::A.new(question.name, 3600, address: "192.168.1.1")]
  end
end

server = ZDNSServer.new
server.start
server.join
