class RegexpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      Regexp.new(value.to_s)
    rescue RegexpError
      record.errors.add(attribute, 'must_be_valid_regexp')
    end
  end
end
