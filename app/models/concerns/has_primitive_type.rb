module HasPrimitiveType
  extend ActiveSupport::Concern

  included do
    enum primitive_type: [:integer, :string, :boolean, :null, :number, :date, :datetime]
  end

end
