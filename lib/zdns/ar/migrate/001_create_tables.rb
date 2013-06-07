require 'active_record'

class CreateTables < ActiveRecord::Migration
  def change
    create_table :as do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :address, :integer, :null => false
      t.column :enable_ptr, :boolean, :null => false, :default => false
    end

    create_table :nss do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :nsdname, :string, :null => false
    end

    create_table :cnames do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :cname, :string, :null => false
    end

    create_table :soas do |t|
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

    create_table :mxs do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :preference, :integer, :null => false
      t.column :exchange, :string, :null => false
    end

    create_table :txts do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :txt_data, :string, :null => false
    end

    create_table :aaaas do |t|
      t.column :soa_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :ttl, :integer
      t.column :address, :string, :null => false
      t.column :enable_ptr, :boolean, :null => false, :default => false
    end

    create_table :lookups do |t|
      t.column :fqdn, :string, :null => false
      t.column :soa_id, :integer, :null => false
      t.column :record_type, :integer, :null => false
      t.column :record_id, :integer, :null => false
    end
    add_index :lookups, [:fqdn, :record_type]
  end
end
