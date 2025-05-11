class FlowerSpot < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  enum parking: { 不明: 0, 駐車場有り: 1, 駐車場無し: 2 }, _prefix: true
  enum fee_type: { 不明: 0, 無料: 1, 有料: 2, 一部有料: 3 }, _prefix: true

  validates :name, presence: true, length: { maximum: 100}
  validates :address, presence: true, length: { maximum: 255 }
  validates :peak_season_months, presence: true
  validates :photos, presence: true
end
