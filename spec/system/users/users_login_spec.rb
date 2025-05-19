require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  let!(:user) { create(:user) }

  describe "ログイン" do
    before do
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    it "ログインすると、ルートパスに遷移すること" do
      expect(current_path).to eq root_path
    end

    it "ログイン成功時にフラッシュメッセージが表示されること" do
      expect(page).to have_content "ログインしました。"
    end

    it "ヘッダーにログアウトリンクが表示されること" do
      expect(page).to have_link "ログアウト"
    end
  end

  describe "ログアウト" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
      within "header" do
        click_link "ログアウト"
      end
    end

    it "ルートパスに遷移すること" do
      expect(current_path).to eq root_path
    end

    it "ログアウト成功のフラッシュメッセージが表示されること" do
      expect(page).to have_content "ログアウトしました。"
    end

    it "ログインリンクが表示され、ログアウトリンクが消えること" do
      expect(page).to have_link "ログイン"
      expect(page).not_to have_link "ログアウト"
    end
  end
end
