#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'

ZDNS::Server.new.run
