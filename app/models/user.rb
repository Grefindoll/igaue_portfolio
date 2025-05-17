class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :flower_spots, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_flower_spots, through: :favorites, source: :flower_spot

  validates :username, presence: true, length: { maximum: 50 }

  def admin?
    admin # adminカラムがtrueならtrue、falseならfalseを返す
  end

  def favorited?(flower_spot)
    self.favorite_flower_spots.include?(flower_spot)
  end
end
