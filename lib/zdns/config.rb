require 'tmpdir'
require 'active_support/core_ext'

module ZDNS
  class Config < Hash
    DEFAULT_CONFIG_PATH = "/usr/local/zdns/zdns.yml"

    DEFAULT_CONFIG = {
      :server => {
        :host => "0.0.0.0",
        :port => 53,
        :daemon => {
          :application => "zdnsserver",
          :log_file => "/usr/local/zdns/zdnsserver.log",
          :pid_file => "/usr/local/zdns/zdnsserver.pid",
          :sync_log => true,
          :working_dir => Dir.tmpdir,
        },
      },
      :manager => {
        :BindAddress => "0.0.0.0",
        :Port => 9053,
        :daemon => {
          :application => "zdnsmanager",
          :log_file => "/usr/local/zdns/zdnsmanager.log",
          :pid_file => "/usr/local/zdns/zdnsmanager.pid",
          :sync_log => true,
          :working_dir => Dir.tmpdir,
        },
      },
      :database => {
        :adapter => "sqlite3",
        :database  => "/usr/local/zdns/zdns.db",
      },
    }

    def initialize
      super
      self.update(DEFAULT_CONFIG)
    end

    def load(hash)
      hash = hash.dup

      hash.symbolize_keys!
      hash[:server].symbolize_keys! rescue nil
      hash[:server][:daemon].symbolize_keys! rescue nil
      hash[:manager].symbolize_keys! rescue nil
      hash[:manager][:daemon].symbolize_keys! rescue nil
      hash[:database].symbolize_keys! rescue nil

      self.deep_merge!(hash)
    end

    def load_file(file_path, type=nil)
      # type
      unless type
        type = "yaml"
        m = file_path.downcase.match(/\.([a-z]+)$/)
        if m
          type = m[1]
        end
      end

      load_method = "load_#{type}"
      if respond_to?(load_method)
        send(load_method, file_path)
      else
        raise RuntimeError, "config file type is not supported: #{type}"
      end
    end

    def load_yaml(file_path)
      require 'yaml'

      hash = YAML.load_file(file_path)
      self.load(hash)
    end
    alias :load_yml :load_yaml

    def load_json(file_path)
      require 'json'

      open(file_path, "r") do |f|
        hash = JSON.load(io)
        self.load(hash)
      end
    end

    def load_default_file
      if File.exists?(DEFAULT_CONFIG_PATH)
        load_file(DEFAULT_CONFIG_PATH)
      end
    end
  end
end
