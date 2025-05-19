FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..12) }
    email { Faker::Internet.unique.email }
    password { 'password123desu' }
  end
end
