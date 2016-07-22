module Cumulus
  module RDS
    class InstanceConfig
      attr_reader :name, :port, :type, :engine, :engine_version, :storage_type, :storage_size, :master_username, :security_groups, :subnet, :database, :public, :backup_period, :buckup_window, :enhanced_monitoring, :auto_upgrade, :upgrade_window

      def initialize(name, json = nil)
        @name = name
        unless json.nil?
          @port = json["port"]
          @type = json["type"]
          @engine = json["engine"]
          @engine_version = json["engine_version"]
          @storage_type = json["storage_type"]
          @storage_size = json["storage_size"]
          @master_username = json["master_username"]
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
      end

      def to_hash
        {
          "port" => @port,
          "type" => @type,
          "engine" => @engine,
          "engine_version" => @engine_version,
          "storage_type" => @storage_type,
          "storage_size" => @storage_size,
          "master_username" => @username,
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

      def populate!(aws_instance)
        @port = aws_instance[:endpoint][:port]
        @type = aws_instance[:db_instance_class].reverse.chomp("db.".reverse).reverse # remove the 'db.' that prefixes the string
        @engine = aws_instance[:engine]
        @engine_version = aws_instance[:engine_version]
        @storage_type = aws_instance[:storage_type] # 'gp2'
        @storage_size = aws_instance[:allocated_storage]
        @master_username = aws_instance[:master_username]
        @security_groups = aws_instance[:db_security_groups] # an array. TODO: need to verify elements
        @subnet = nil#aws_instance[:db_subnet_group] # TODO: another struct inside this one
        @database = aws_instance[:db_name]
        @public = aws_instance[:publicly_accessible]
        @backup_period = aws_instance[:backup_retention_period]
        @backup_window = aws_instance[:preferred_backup_window]
        @enhanced_monitoring = aws_instance[:enhanced_monitoring_resource_arn] # TODO: what does this return
        @auto_upgrade = aws_instance[:auto_minor_version_upgrade]
        @upgrade_window = aws_instance[:preferred_backup_window]
        self # return the instanceconfig
      end

    end
  end
end
