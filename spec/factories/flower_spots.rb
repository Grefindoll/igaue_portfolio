FactoryBot.define do
  factory :flower_spot do
    name { Faker::Lorem.sentence(word_count: 3) }
    address { Faker::Address.full_address }
    peak_season_months { [Faker::Number.between(from: 1, to: 12)] }
    parking { FlowerSpot.parkings.keys.sample }
    fee_type { FlowerSpot.fee_types.keys.sample }

    association :user

    after(:build) do |flower_spot|
      flower_spot.flower_photos.attach(
        io: File.open("spec/fixtures/files/sample.jpg"),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
