require "rds/loader/Loader"
require "common/manager/Manager"

module Cumulus
  module RDS
    class Manager < Common::Manager
      def resource_name
        "RDS Database"
      end

      def local_resources
        @local_resources ||= Hash[Loader.instances.map { |local| [local.name, local] }]
      end

    end
  end
end
