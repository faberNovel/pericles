module News
  class Change < ActiveModelSerializers::Model
    attributes :key, :old, :new
  end
end
