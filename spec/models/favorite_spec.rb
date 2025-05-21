require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:flower_spot) { create(:flower_spot) }

  describe 'バリデーション' do
    it 'ユーザーとお花畑が関連付けられている場合は有効であること' do
      favorite = build(:favorite, user: user, flower_spot: flower_spot)
      expect(favorite).to be_valid
    end

    it '同じユーザーが同じお花畑を重複してお気に入り登録できないこと' do
      create(:favorite, user: user, flower_spot: flower_spot)
      duplicate_favorite = build(:favorite, user: user, flower_spot: flower_spot)
      expect(duplicate_favorite).not_to be_valid
    end
  end
end
