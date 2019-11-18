class HashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value
    record.errors.add(attribute, :value_must_be_hash) unless value.is_a? Hash
  end
end
