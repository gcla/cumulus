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

    end
  end
end
