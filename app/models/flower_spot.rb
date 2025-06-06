class FlowerSpot < ApplicationRecord
  belongs_to :user
  has_many_attached :flower_photos
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  enum :parking, { unknown: 0, available: 1, not_available: 2 }, prefix: true
  enum :fee_type, { unknown: 0, free: 1, paid: 2, partially_paid: 3 }, prefix: true

  validates :name, presence: true, length: { maximum: 100 }
  validates :address, presence: true, length: { maximum: 255 }
  validates :peak_season_months, presence: true
  validates :flower_photos, presence: true

  # --- ここからGeocoding関連の設定 ---
  validate :no_duplicate_flower_spots_nearby
  geocoded_by :address
  after_validation :geocode, if: :should_geocode?
  # --- ここまで ---

  private

  def no_duplicate_flower_spots_nearby
    return if latitude.nil? || longitude.nil?

    nearby = FlowerSpot.near([latitude, longitude], 0.1). # 半径0.1km = 100m
      where.not(id: id)

    if nearby.exists?
      errors.add(:address, '近くにすでに同じようなスポットがあります')
    end
  end

  def should_geocode?
    address.present? && address_changed?
  end
end
