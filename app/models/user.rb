class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :flower_spots, dependent: :destroy

  def admin?
    admin # adminカラムがtrueならtrue、falseならfalseを返す
  end
end
