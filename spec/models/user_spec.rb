require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do

    it '有効な属性（ユーザー名、メールアドレス、パスワードがある場合）は有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'ユーザー名がない場合は無効であること' do
      user_without_username = build(:user, username: nil)
      expect(user_without_username).not_to be_valid
      expect(user_without_username.errors[:username]).to include("を入力してください")
    end

    it 'メールアドレスがない場合は無効であること' do
      user_without_email = build(:user, email: nil)
      expect(user_without_email).not_to be_valid
      expect(user_without_email.errors[:email]).to include("を入力してください")
    end

    it 'パスワードがない場合は無効であること' do
      user_without_password = build(:user, password: nil)
      expect(user_without_password).not_to be_valid
    end
  end
end
