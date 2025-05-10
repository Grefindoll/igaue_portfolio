class FlowerSpot < ApplicationRecord
  belongs_to :user

  enum parking: { unknown: 0, available: 1, not_available: 2 }
  enum fee_type: { unknown: 0, free: 1, paid: 2, partial_paid: 3 }
end
