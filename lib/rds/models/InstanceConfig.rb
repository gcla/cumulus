module Cumulus
  module RDS
    class InstanceConfig
      attr_reader :name

      def initialize(name, json = nil)
        @name = name
      end

    end
  end
end
