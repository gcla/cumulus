module Cumulus
  module RDS
    require "common/commands"
    class Commands < Cumulus::Common::Commands

      def self.manager
        require "rds/manager/Manager"
        Cumulus::RDS::Manager.new
      end

    end
  end
end
