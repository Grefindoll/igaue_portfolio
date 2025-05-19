FactoryBot.define do
  factory :favorite do
    association :user
    association :flower_spot
  end
end
