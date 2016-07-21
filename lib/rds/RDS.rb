require "conf/Configuration"
require "aws-sdk"

module Cumulus
  module RDS
    class << self
      @@client = Aws::RDS::Client.new(Configuration.instance.client)

      def instances
        @instances ||= init_instances
      end

      def named_instances
        Hash[instances.map { |instance| [instance.name, instance] }]
      end

      private

      def init_instances
        @@client.describe_db_instances.db_instances
      end

    end
  end
end
