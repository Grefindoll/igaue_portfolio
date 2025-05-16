class FlowerSpot < ApplicationRecord
  belongs_to :user
  has_many_attached :flower_photos

  enum parking: { unknown: 0, available: 1, not_available: 2 }, _prefix: true
  enum fee_type: { unknown: 0, free: 1, paid: 2, partially_paid: 3 }, _prefix: true

  validates :name, presence: true, length: { maximum: 100}
  validates :address, presence: true, length: { maximum: 255 }
  validates :peak_season_months, presence: true
  validates :flower_photos, presence: true

  # --- ここからGeocoding関連の設定を追加・確認 ---
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
  validate :no_duplicate_flower_spots_nearby, if: -> { address.present? && (new_record? || address_changed?) }

  private

  def no_duplicate_flower_spots_nearby
    if latitude.present? && longitude.present?
      # 検索する半径をkm単位で指定します (100m = 0.1km)
      search_radius_km = 0.1
      nearby_spots_query = FlowerSpot.near([latitude, longitude], search_radius_km, units: :km)

      conflicting_spots = if new_record?
                            nearby_spots_query
                          else
                            nearby_spots_query.where.not(id: self.id)
                          end

      # もし重複するお花畑が見つかった場合、エラーを追加します。
      if conflicting_spots.exists?
        # errors.add の第一引数はエラーを追加する属性名、第二引数はエラーメッセージ(またはi18nキー)、第３引数以降は、エラーメッセージ内で使える変数です。
        errors.add(:address, :duplicate_spot_nearby, distance: (search_radius_km * 1000).to_i)
      end
    elsif address.present? && (new_record? || address_changed?)
      # 住所は入力されているが、何らかの理由で緯度経度が取得できなかった場合のエラー処理です。(例: Geocoding APIの制限超過、無効な住所など)
    end
  end
end
