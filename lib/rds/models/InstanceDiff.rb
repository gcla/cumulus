require "common/models/Diff"
require "common/models/TagsDiff"

module Cumulus
  module RDS
    module InstanceChange
      include Common::DiffChange

      PORT = Common::DiffChange.next_change_id
      TYPE = Common::DiffChange.next_change_id
      ENGINE = Common::DiffChange.next_change_id
      STORAGE = Common::DiffChange.next_change_id
      USERNAME = Common::DiffChange.next_change_id
      SECURITY_GROUPS = Common::DiffChange.next_change_id
      SUBNET = Common::DiffChange.next_change_id
      DATABASE = Common::DiffChange.next_change_id
      PUBLIC = Common::DiffChange.next_change_id
      BACKUP = Common::DiffChange.next_change_id
      MONITORING = Common::DiffChange.next_change_id
      UPGRADE = Common::DiffChange.next_change_id
    end

    # Public: Represents a single difference between local configuration and AWS configuration
    class InstanceDiff < Common::Diff
      include InstanceChange

      def aws_name
        @aws[:db_instance_identifier]
      end

      def asset_type
        case @type
        when PORT then "Port"
        when TYPE then "Type"
        when ENGINE then "Engine"
        when STORAGE then "Storage"
        when USERNAME then "Username"
        when SECURITY_GROUPS then "Security Groups"
        when SUBNET then "Subnet"
        when DATABASE then "Database Name"
        when PUBLIC then "Public Facing"
        when BACKUP then "Backup"
        when MONITORING then "Monitoring"
        when UPGRADE then "Upgrade"
        else
          "RDS Instance"
        end
      end

      def diff_string
        unless @type == SECURITY_GROUPS
          [
            "#{asset_type}:",
            Colors.aws_changes("\tAWS - #{aws}"),
            Colors.local_changes("\tLocal - #{local}"),
          ].join("\n")
        else
          [
            "#{asset_type}:",
            @changes.removed.map { |sg| Colors.unmanaged("\t#{sg}") },
            @changes.added.map { |sg| Colors.added("\t#{sg}") }
          ].flatten.join("\n")
        end
      end
    end
  end
end
