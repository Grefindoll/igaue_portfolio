require 'rails_helper'

RSpec.describe FlowerSpot, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    it '有効な属性の場合は有効であること' do
      flower_spot = build(:flower_spot, user: user)
      expect(flower_spot).to be_valid
    end

    it '名前がない場合は無効であること' do
      flower_spot_without_name = build(:flower_spot, user: user, name: nil)
      expect(flower_spot_without_name).not_to be_valid
    end

    it '住所がない場合は無効であること' do
      flower_spot_without_address = build(:flower_spot, user: user, address: nil)
      expect(flower_spot_without_address).not_to be_valid
    end

    it '投稿ユーザーがいない場合は無効であること' do
      flower_spot_without_user = build(:flower_spot, user: nil)
      expect(flower_spot_without_user).not_to be_valid
    end

    it '見頃の時期 (peak_season_months) がない場合は無効であること' do
      flower_spot_without_peak_season = build(:flower_spot, user: user, peak_season_months: [])
      expect(flower_spot_without_peak_season).not_to be_valid
    end

    it '写真 (flower_photos) がない場合は無効であること' do
      flower_spot = build(:flower_spot, user: user)
      flower_spot.flower_photos.detach
      expect(flower_spot).not_to be_valid
    end
  end

  describe '重複投稿防止ロジック (no_duplicate_flower_spots_nearby)' do
    let!(:existing_spot) do
      create(:flower_spot, user: user, address: '東京都千代田区千代田1-1')
    end

    it '既存のスポットから十分に離れた場所であれば有効であること' do
      far_spot = build(:flower_spot, user: user, address: '北海道札幌市中央区北1条西2丁目')
      expect(far_spot).to be_valid
    end

    it '既存のスポットの半径100m以内に別のスポットを登録しようとすると無効であること' do
      near_spot = build(:flower_spot, user: user, address: '東京都千代田区千代田1-1')
      near_spot.save
      expect(near_spot).not_to be_valid
    end
  end

  describe 'Geocoding連携 (after_validation :geocode)' do
    it '有効な住所が設定されて保存されると、緯度と経度が自動で設定されること' do
      flower_spot = build(:flower_spot, user: user, address: '東京タワー')
      flower_spot.save
      expect(flower_spot.latitude).to be_present
      expect(flower_spot.longitude).to be_present
    end

    it '無効な住所やジオコーディングできない住所の場合、緯度経度は設定されないこと' do
      flower_spot = build(:flower_spot, user: user, address: '存在しないめちゃくちゃな住所')
      expect(flower_spot.latitude).to be_nil
      expect(flower_spot.longitude).to be_nil
    end
  end
end
