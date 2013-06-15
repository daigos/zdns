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

config = {
  :server => {
    :host => "0.0.0.0",
    :port => 53,
  },
  :daemon => {
    :log_file => "/tmp/zdns_simple_daemon.log",
    :pid_file => "/tmp/zdns_simple_daemon.pid",
    :sync_log => true,
    :working_dir => "/tmp",
  },
}

subcommand = ARGV[0] || ""
ZDNS::Daemon.spawn!(subcommand, config)
