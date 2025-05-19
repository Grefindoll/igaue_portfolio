require 'rails_helper'

RSpec.describe "UsersProfileEdit", type: :system do
  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    click_link "マイページ"
    click_link "プロフィールを編集する"
  end

  it "プロフィール編集フォームが正しく表示されること" do
    expect(page).to have_content "プロフィールの編集"
    expect(page).to have_field "ニックネーム", with: user.username
  end

  context "有効な入力の場合" do
    before do
      attach_file "プロフィール画像", Rails.root.join("spec/fixtures/files/sample.jpg")
      fill_in "ニックネーム", with: "新しい名前"
      fill_in "自己紹介", with: "新しい自己紹介文です。"
      click_button "登録する"
    end

    it "プロフィールを更新できること" do
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "プロフィールを更新しました。"
      expect(page).to have_content "新しい名前"
      expect(page).to have_content "新しい自己紹介文です。"
      expect(page).to have_selector("img[alt = '新しい名前さんのプロフィール画像']")
    end

    it "自己紹介文が表示されること" do
      expect(page).to have_content "新しい自己紹介文です。"
    end
  end

  context "無効な入力の場合" do
    it "エラーメッセージが表示されること" do
      fill_in "ニックネーム", with: ""
      click_button "登録する"

      expect(page).to have_content "1件のエラーにより、このプロフィールは保存できませんでした"
      expect(page).to have_content "ニックネーム を入力してください"
    end
  end
end
