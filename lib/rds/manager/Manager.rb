require "rds/RDS"
require "rds/loader/Loader"
require "common/manager/Manager"

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

    end
  end
end
