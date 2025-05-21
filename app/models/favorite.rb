class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :flower_spot

  validates :user_id, uniqueness: { scope: :flower_spot_id }
end
