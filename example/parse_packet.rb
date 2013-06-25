#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

bin = open("#{File.dirname(__FILE__)}/example_packet.bin", "r"){|f| f.read}
bin.force_encoding("ASCII-8BIT")

# parse
packet = ZDNS::Packet::new_from_buffer(bin)
p packet
puts

# build
bin2 = packet.to_bin.force_encoding("ASCII-8BIT")
p bin
p bin2
p bin==bin2
puts

# dump
puts packet.to_dig
