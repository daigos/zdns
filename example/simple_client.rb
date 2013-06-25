#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

client = ZDNS::Client.new("8.8.8.8", 53)
packet = client.lookup("google.com.", ZDNS::Packet::Type::ANY, ZDNS::Packet::Class::IN)

puts packet.to_dig
