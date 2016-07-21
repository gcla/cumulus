module Cumulus
  module RDS
    class InstanceConfig
      attr_reader :name, :port, :type, :private_ip_address, :service, :username

      def initialize(name, json = nil)
        @name = name
        @port = json["port"].to_i
        @type = json["type"].to_s
        @private_ip_address = json["private-ip-address"].to_s
        @service = json["service"].to_s
        @username = json["username"].to_s
      end

      def to_hash
        {
          "port" => @port.to_i,
          "type" => @type.to_s,
          "private-ip-address" => @private_ip_address.to_s,
          "service" => @service.to_s
          "username" => @username.to_s
        }
      end

    end
  end
end
