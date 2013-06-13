#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)+"/../lib"

require 'zdns'
require 'zdns/ar'

# start server
server_options = {
  :host => '0.0.0.0',
  :port => 53,
  :activerecord => {
    :adapter => "sqlite3",
    :database  => "/tmp/zdns_simple_ar_server.db",
  }
}
server = ZDNS::AR::Server.new(server_options)
server.start

# create sample data
ActiveRecord::Base.logger = Logger.new(STDOUT)

soa = ZDNS::AR::Model::SoaRecord.where(
  :name => "example.com.",
  :ttl => 3600,
  :mname => "ns.example.com.",
  :rname => "root.example.com.",
  :serial => 20130606,
  :refresh => 14400,
  :retry => 3600,
  :expire => 604800,
  :minimum => 7200,
).first_or_create!

a_root = ZDNS::AR::Model::ARecord.where(
  :soa_record_id => soa.id,
  :name => "@",
  :ttl => nil,
  :address => IPAddr.new("192.168.1.1").to_i,
).first_or_create!

a_www = ZDNS::AR::Model::ARecord.where(
  :soa_record_id => soa.id,
  :name => "www",
  :ttl => 120,
  :address => IPAddr.new("192.168.1.1").to_i,
).first_or_create!

ns = ZDNS::AR::Model::NsRecord.where(
  :soa_record_id => soa.id,
  :name => "@",
  :ttl => nil,
  :nsdname => "ns.example.com.",
).first_or_create!

# join server
server.join
