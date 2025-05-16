class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :flower_spots, dependent: :destroy

  validates :username, presence: true, length: { maximum: 50 }

  def admin?
    admin # adminカラムがtrueならtrue、falseならfalseを返す
  end
end
