module News
  class HeaderAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['name']
    end

    def url
      # TODO: Clement Villain 2019-03-04
      # Handle polymorphic association http_message
    end
  end
end
