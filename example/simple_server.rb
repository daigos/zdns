#!/usr/bin/ruby

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'zdns'

class ZDNSServer < ZDNS::Server
  def lookup_answers(question)
    [ZDNS::Packet::RR::A.new(question.name, 3600, address: "192.168.1.1")]
  end

  def lookup_authorities(question)
    []
  end

  def lookup_additionals(authority)
    []
  end
end

server = ZDNSServer.new
server.start
server.join
