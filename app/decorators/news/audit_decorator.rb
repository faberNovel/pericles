module News
  class AuditDecorator < Draper::Decorator
    delegate_all

    alias_method :audit, :object

    def to_s
      text
    end

    def name
      ''
    end

    def changes
      h.render('changes', audited_changes: map_changes)
    end

    def url
      ''
    end

    private

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
          Change.new(key: key, old: value.first.inspect, new: value.last.inspect)
        end
      end
    end

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
      "#{audit.auditable_type} #{url} has been updated: #{changes}"
    end

    def created_text
      "A new #{audit.auditable_type} #{name} has been created: #{url}"
    end
  end
end
