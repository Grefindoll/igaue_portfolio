FactoryBot.define do
  factory :flower_spot do
    name { Faker::Lorem.sentence(word_count: 3) }
    address { Faker::Address.full_address }
    peak_season_months { [Faker::Number.between(from: 1, to: 12)] }
    parking { FlowerSpot.parkings.keys.sample }
    fee_type { FlowerSpot.fee_types.keys.sample }

    association :user

    after(:build) do |flower_spot|
      file_path = Rails.root.join('spec', 'fixtures', 'files', 'sample.jpg')
      if File.exist?(file_path)
        flower_spot.flower_photos.attach(
          io: File.open(file_path),
          filename: 'sample.jpg',
          content_type: 'image/jpeg'
        )
      else
        puts "spec/fixtures/files/sample.jpg が見つかりません。"
      end
    end
  end
end
