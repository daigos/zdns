#!/usr/bin/ruby

$LOAD_PATH << File.expand_path(__FILE__+"/../../lib")
require 'test/unit'
require 'zdns'
require 'zdns/ar'

test_dir = File.dirname(__FILE__)
exit Test::Unit::AutoRunner.run(true, test_dir)
