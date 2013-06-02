#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

server = ZDNS::Server.new
server.run
server.join
