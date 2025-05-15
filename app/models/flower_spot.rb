class FlowerSpot < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  enum parking: { unknown: 0, available: 1, not_available: 2 }, _prefix: true
  enum fee_type: { unknown: 0, free: 1, paid: 2, partially_paid: 3 }, _prefix: true

  validates :name, presence: true, length: { maximum: 100}
  validates :address, presence: true, length: { maximum: 255 }
  validates :peak_season_months, presence: true
  validates :photos, presence: true
end
