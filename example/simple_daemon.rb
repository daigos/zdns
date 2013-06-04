#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

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

server_options = {
  :host => '0.0.0.0',
  :port => 53,
}
daemon_options = {
  :log_file => '/tmp/simple_zdns.log',
  :pid_file => '/tmp/simple_zdns.pid',
  :sync_log => true,
  :working_dir => File.dirname(__FILE__),
}
args = ARGV + [ZDNSServer.new(server_options)]

ZDNS::Daemon.spawn!(daemon_options, args)
