require 'active_record'

class CreateTables < ActiveRecord::Migration
  def change
    create_table :a_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :address, :string, :null => false
      t.column :enable_ptr, :boolean, :null => false, :default => false
    end

    create_table :ns_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :nsdname, :string, :null => false
    end

    create_table :cname_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :cname, :string, :null => false
    end

    create_table :soa_records do |t|
      t.column :name, :string, :null => false
      t.column :ttl, :integer, :null => false
      t.column :mname, :string, :null => false
      t.column :rname, :string, :null => false
      t.column :serial, :integer, :null => false
      t.column :refresh, :integer, :null => false
      t.column :retry, :integer, :null => false
      t.column :expire, :integer, :null => false
      t.column :minimum, :integer, :null => false
    end
    add_index :soa_records, :name, :unique => true

    create_table :mx_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :preference, :integer, :null => false
      t.column :exchange, :string, :null => false
    end

    create_table :txt_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :txt_data, :string, :null => false
    end

    create_table :aaaa_records do |t|
      t.column :soa_record_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :address, :string, :null => false
      t.column :enable_ptr, :boolean, :null => false, :default => false
    end

    create_table :forward_lookups do |t|
      t.column :fqdn, :string, :null => false
      t.column :soa_record_id, :integer, :null => false
      t.column :record_type, :integer, :null => false
      t.column :record_id, :integer, :null => false
    end
    add_index :forward_lookups, [:fqdn, :record_type]

    create_table :reverse_lookups do |t|
      t.column :fqdn, :string, :null => false
      t.column :soa_record_id, :integer, :null => false
      t.column :record_type, :integer, :null => false
      t.column :record_id, :integer, :null => false
    end
    add_index :reverse_lookups, :fqdn
    add_index :reverse_lookups, [:fqdn, :record_type]

    # soa record
    soa = ZDNS::AR::Model::SoaRecord.create(
      :name => "example.com.",
      :ttl => 3600,
      :mname => "ns.example.com.",
      :rname => "root.example.com.",
      :serial => 20130606,
      :refresh => 14400,
      :retry => 3600,
      :expire => 604800,
      :minimum => 7200,
    )

    # a record
    a_root = ZDNS::AR::Model::ARecord.create(
      :soa_record_id => soa.id,
      :name => "@",
      :ttl => nil,
      :address => "192.168.1.80",
      :enable_ptr => true,
    )

    a_www = ZDNS::AR::Model::ARecord.create(
      :soa_record_id => soa.id,
      :name => "www",
      :ttl => 120,
      :address => "192.168.1.80",
      :enable_ptr => true,
    )

    # aaaa record
    aaaa_root = ZDNS::AR::Model::AaaaRecord.create(
      :soa_record_id => soa.id,
      :name => "@",
      :ttl => nil,
      :address => "2001:db8::80",
      :enable_ptr => true,
    )

    aaaa_www = ZDNS::AR::Model::AaaaRecord.create(
      :soa_record_id => soa.id,
      :name => "www",
      :ttl => 120,
      :address => "2001:db8::80",
      :enable_ptr => true,
    )

    # cname record
    cname = ZDNS::AR::Model::CnameRecord.create(
      :soa_record_id => soa.id,
      :name => "www2",
      :ttl => 120,
      :cname => "www.example.com.",
    )

    # ns record
    a_ns = ZDNS::AR::Model::ARecord.create(
      :soa_record_id => soa.id,
      :name => "ns",
      :ttl => 120,
      :address => "192.168.1.53",
      :enable_ptr => true,
    )

    aaaa_ns = ZDNS::AR::Model::AaaaRecord.create(
      :soa_record_id => soa.id,
      :name => "ns",
      :ttl => 120,
      :address => "2001:db8::53",
      :enable_ptr => true,
    )

    ns = ZDNS::AR::Model::NsRecord.create(
      :soa_record_id => soa.id,
      :name => "@",
      :ttl => nil,
      :nsdname => "ns.example.com.",
    )

    # mx record
    a_mx = ZDNS::AR::Model::ARecord.create(
      :soa_record_id => soa.id,
      :name => "mx",
      :ttl => 120,
      :address => "192.168.1.25",
      :enable_ptr => true,
    )

    aaaa_mx = ZDNS::AR::Model::AaaaRecord.create(
      :soa_record_id => soa.id,
      :name => "mx",
      :ttl => 120,
      :address => "2001:db8::25",
      :enable_ptr => true,
    )

    mx = ZDNS::AR::Model::MxRecord.create(
      :soa_record_id => soa.id,
      :name => "@",
      :ttl => 120,
      :preference => 10,
      :exchange => "mx.example.com.",
    )

    # txt record
    txt = ZDNS::AR::Model::TxtRecord.create(
      :soa_record_id => soa.id,
      :name => "@",
      :ttl => 120,
      :txt_data => "v=spf1 +ip4:192.168.1.25/32 -all",
    )
  end
end
