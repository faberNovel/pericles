FactoryBot.define do

  sequence :name do |n|
    "Scheme #{n}"
  end

  factory :scheme do
    name { generate(:name) }
    regexp '(azertyuiop)+'
  end
end
