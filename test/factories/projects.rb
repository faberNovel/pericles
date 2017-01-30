FactoryGirl.define do

  sequence :project_title do |n|
    "Project #{n}"
  end

  factory :project do
    title { generate(:project_title) }
    description "That's it !"
  end

end