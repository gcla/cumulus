module Cumulus
  module RDS
    class InstanceConfig
      attr_reader :name, :port, :type, :service, :engine_version, :storage_type, :storage_size, :username, :password, :security_groups, :subnet, :database, :public, :backup_period, :buckup_window, :enhanced_monitoring, :auto_upgrade, :upgrade_window

      def initialize(name, json = nil)
        @name = name
        @port = json["port"]
        @type = json["type"]
        @service = json["engine"]
        @engine_version = json["engine_version"]
        @storage_type = json["storage_type"]
        @storage_size = json["storage_size"]
        @master_username = json["master_username"]
        @master_password = json["master_password"]
        @security_groups = json["security-groups"]
        @subnet = json["subnet"]
        @database = json["database"]
        @public = json["public"]
        @backup_period = json["backup_period"]
        @backup_window = json["buckup_window"]
        @enhanced_monitoring = json["enhanced_monitoring"]
        @auto_upgrade = json["auto_upgrade"]
        @upgrade_window = json["upgrade_window"]
      end

      def to_hash
        {
          "port" => @port,
          "type" => @type,
          "engine" => @service,
          "engine_version" => @engine_version,
          "storage_type" => @storage_type,
          "storage_size" => @storage_size,
          "master_username" => @username,
          "master_password" => @password,
          "security-groups" => @security_groups,
          "subnet" => @subnet,
          "database" => @database,
          "public" => @public,
          "backup_period" => @backup_period,
          "buckup_window" => @buckup_window,
          "enhanced_monitoring" => @enhanced_monitoring,
          "auto_upgrade" => @auto_upgrade,
          "upgrade_window" => @upgrade_window,
        }
      end

    end
  end
end
