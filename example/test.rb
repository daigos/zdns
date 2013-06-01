#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

p ZDNS::Packet::RR::A.new("a", 3600).to_hash
p ZDNS::Packet::RR::A.new("a", 3600) == ZDNS::Packet::RR::A.new("a", 3600, address:"192.168.1.1")
