module News
  class AuditDecorator < Draper::Decorator
    delegate_all

    alias_method :audit, :object

    def partial_name
      nil
    end

    def link_name
      ''
    end

    def name
      ''
    end

    def changes
      h.render('audits/changes', audited_changes: map_changes)
    end

    def url
      ''
    end

    def action_css_class
      if audit.action == 'create'
        'create'
      elsif audit.action == 'update'
        'update'
      elsif audit.action == 'destroy'
        'destroy'
      end
    end

    def map_changes
      audit.audited_changes.map do |key, value|
        if key.ends_with?('_id')
          begin
            klass = audit.auditable_type.constantize
            attribute_class = klass.reflections.values.find { |reflection| reflection.foreign_key == key }.klass
            old = attribute_class.find(value.first).name
            new = attribute_class.find(value.last).name
            Change.new(key: key.sub(/_id$/, ''), old: old, new: new)
          rescue NameError, ActiveRecord::RecordNotFound
            Change.new(key: key, old: value.first.inspect, new: value.last.inspect)
          end
        else
          Change.new(key: key, old: value.first, new: value.last)
        end
      end
    end
  end
end
