require "rds/RDS"
require "rds/loader/Loader"
require "common/manager/Manager"
require "rds/models/InstanceDiff"
require "conf/Configuration"
require "io/console"

module Cumulus
  module RDS
    class Manager < Common::Manager
      def resource_name
        "RDS Database Instance"
      end

      def local_resources
        @local_resources ||= Hash[Loader.instances.map { |local| [local.name, local] }]
      end

      def aws_resources
        @aws_resources ||= RDS::named_instances
      end

      def unmanaged_diff(aws)
        InstanceDiff.unmanaged(aws)
      end

      def added_diff(local)
        InstanceDiff.added(local)
      end

      def diff_resource(local, aws)
        puts Colors.blue("Processing #{local.name}...")
        cumulus_version = InstanceConfig.new(local.name).populate!(aws)
        local.diff(cumulus_version)
      end

      def migrate
        puts Colors.blue("Will migrate #{RDS.instances.length} instances")

        # Create the directories
        rds_dir = "#{@migration_root}/rds"
        instances_dir = "#{rds_dir}/instances"

        if !Dir.exists?(@migration_root)
          Dir.mkdir(@migration_root)
        end
        if !Dir.exists?(rds_dir)
          Dir.mkdir(rds_dir)
        end
        if !Dir.exists?(instances_dir)
          Dir.mkdir(instances_dir)
        end

        RDS.named_instances.each do |name, instance|
          puts "Migrating #{name}..."

          cumulus_instance = InstanceConfig.new(name).populate!(instance)

          json = JSON.pretty_generate(cumulus_instance.to_hash)
          File.open("#{instances_dir}/#{name}.json", "w") { |f| f.write(json) }
        end
      end

      def create(local)
        errors = Array.new

        if local.name.nil?
          errors << "instance name is required"
        end

        if local.type.nil?
          errors << "instance type is required"
        end

        if local.engine.nil?
          errors << "database engine is required"
        end

        if !errors.empty?
          puts "Could not create #{local.name}:"
          errors.each { |e| puts "\t#{e}"}
          exit StatusCodes::EXCEPTION
        end

        master_password = unless local.master_username.nil?
          # prompt for the user's password (discreetly)
          print "enter a password for #{local.master_username}: "
          password = STDIN.noecho(&:gets).chomp
          puts "\n"
          password
        else
          nil
        end

        client = Aws::RDS::Client.new(Configuration.instance.client)

        client.create_db_instance({
          db_name: local.database,
          db_instance_identifier: local.name, # required
          allocated_storage: local.storage_size,
          db_instance_class: "db." + local.type, # required
          engine: local.engine, # required
          master_username: local.master_username,
          master_user_password: master_password,
          db_security_groups: local.security_groups,
          db_subnet_group_name: local.subnet,
          preferred_maintenance_window: local.upgrade_window,
          backup_retention_period: local.backup_period,
          preferred_backup_window: local.backup_window,
          port: local.port,
          engine_version: local.engine_version,
          auto_minor_version_upgrade: local.auto_upgrade,
          publicly_accessible: local.public_facing,
          storage_type: local.storage_type,
        }.reject { |k, v| v.nil? })

      end

    end
  end
end
