require 'rails_helper'

RSpec.describe "UsersRegistration", type: :system do
  describe "新規登録" do
    before do
      visit root_path
      click_link "新規登録"
      fill_in "ニックネーム", with: "テストユーザーです"
      fill_in "メールアドレス", with: "test_user_dayo@example.com"
    end

    context "有効な場合" do
      before do
        fill_in "パスワード", with: "password123desu"
        click_button "新規登録"
      end

      it "新規登録したら、ルートパスに遷移すること" do
        expect(current_path).to eq root_path
      end

      it "フラッシュメッセージが表示されること" do
        expect(page).to have_content "アカウント登録が完了しました。"
      end

      it "ログアウトボタンが表示されること" do
        expect(page).to have_link "ログアウト"
      end
    end

    context "無効な場合（パスワードが空）" do
      before do
        fill_in "パスワード", with: ""
        click_button "新規登録"
      end

      it "登録画面に留まること" do
        expect(page).to have_content "アカウントの新規登録"
      end

      it "エラーメッセージが表示されること" do
        expect(page).to have_content "パスワード を入力してください"
      end
    end
  end
end
