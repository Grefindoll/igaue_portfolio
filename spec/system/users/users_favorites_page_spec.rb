require 'rails_helper'

RSpec.describe "UsersFavoritesPage", type: :system do
  let(:user_a) { create(:user, username: "ユーザーA") }
  let(:user_b) { create(:user, username: "ユーザーB") }

  let!(:spot1) { create(:flower_spot, name: "お花畑1") }
  let!(:spot2) { create(:flower_spot, name: "お花畑2 (Aのお気に入り)") }
  let!(:spot3) { create(:flower_spot, name: "お花畑3 (Aのお気に入り)") }

  before do
    # ユーザーAがお花畑2と3をお気に入り登録
    create(:favorite, user: user_a, flower_spot: spot2)
    create(:favorite, user: user_a, flower_spot: spot3)

    # ログイン処理 (ユーザーAで)
    visit new_user_session_path
    fill_in "メールアドレス", with: user_a.email
    fill_in "パスワード", with: user_a.password
    click_button "ログイン"
  end

  context "ユーザーAの場合（お気に入り有り）" do
    before do
      visit user_path(user_a)
      click_link "#{user_a.username}さんのお気に入り一覧を見る"
    end

    it "お気に入り一覧ページに遷移すること" do
      expect(current_path).to eq favorites_user_path(user_a)
    end

    it "タイトルが表示されること" do
      expect(page).to have_content "#{user_a.username}さんのお気に入り一覧"
    end

    it "1:お気に入りしたお花畑が表示されること" do
      expect(page).to have_content "お花畑2 (Aのお気に入り)"
    end

    it "2:お気に入りしたお花畑が表示されること" do
      expect(page).to have_content "お花畑3 (Aのお気に入り)"
    end

    it "お気に入りしていないお花畑は表示されないこと" do
      expect(page).not_to have_content "お花畑1"
    end
  end

  context "ユーザーBの場合（お気に入り無し）" do
    before do
      # 一旦ログアウトしてユーザーBで再ログイン
      click_link "ログアウト"
      visit new_user_session_path
      fill_in "メールアドレス", with: user_b.email
      fill_in "パスワード", with: user_b.password
      click_button "ログイン"
      visit user_path(user_b)
      click_link "#{user_b.username}さんのお気に入り一覧を見る"
    end

    it "お気に入り一覧ページに遷移すること" do
      expect(current_path).to eq favorites_user_path(user_b)
    end

    it "タイトルが表示されること" do
      expect(page).to have_content "#{user_b.username}さんのお気に入り一覧"
    end

    it "お気に入りが無い旨の文章が表示されること" do
      expect(page).to have_content "お気に入り登録されているお花畑はまだありません。"
    end

    it "1:お気に入りしていないお花畑が表示されないこと" do
      expect(page).not_to have_content "お花畑1"
    end

    it "2:お気に入りしていないお花畑が表示されないこと" do
      expect(page).not_to have_content "お花畑2 (Aのお気に入り)"
    end
  end
end
