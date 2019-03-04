module News
  class AuditDecorator < Draper::Decorator
    delegate_all

    alias_method :audit, :object

    def to_s
      date + ' ' + author + ' ' + text
    end

    def name
      ''
    end

    def changes
      audit.audited_changes
    end

    def url
      ''
    end

    private

    def text
      if audit.action == 'create'
        created_text
      elsif audit.action == 'update'
        update_text
      elsif audit.action == 'destroy'
        destroy_text
      end
    end

    def destroy_text
      "#{audit.auditable_type} #{name} has been deleted: #{url}"
    end

    def update_text
      "#{audit.auditable_type} has been updated #{changes}: #{url}"
    end

    def created_text
      "A new #{audit.auditable_type} #{name} has been created: #{url}"
    end

    def date
      "<span class=\"date\">#{h.l(audit.created_at)}</span>"
    end

    def author
      "<span class=\"author\">#{audit.user&.name}</span>"
    end
  end
end
