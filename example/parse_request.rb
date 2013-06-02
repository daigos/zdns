#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

bin = open("#{File.dirname(__FILE__)}/request.bin", "r"){|f| f.read}
packet = ZDNS::Packet::new_from_buffer(bin)

p packet
p bin.encode!("ASCII")
p packet.to_bin.encode!("ASCII")

puts
puts packet.dig_dump
