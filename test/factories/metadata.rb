FactoryBot.define do

  sequence :metadatum_name do |n|
    "Metadatum #{n}"
  end

  factory :metadatum do
    project
    name { generate(:metadatum_name) }
    primitive_type :integer
  end
end
