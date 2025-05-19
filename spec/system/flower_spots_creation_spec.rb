require 'rails_helper'

RSpec.describe "FlowerSpotsCreation", type: :system do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "ログインユーザーがお花畑を新規投稿する" do
    context "有効な場合" do
      before do
        visit new_flower_spot_path
        fill_in "お花畑の名前", with: "テストのお花畑"
        fill_in "住所", with: "東京都テスト区テスト1-1-1"
        check "3月"
        check "4月"
        select "駐車場あり", from: "駐車場の有無"
        select "無料", from: "料金体系"
        attach_file "写真 (3枚～5枚程度)", Rails.root.join("spec/fixtures/files/sample.jpg")
      end

      it "お花畑を登録すると、カウントが一つ増えること" do
        expect {
          click_button "登録する"
        }.to change(FlowerSpot, :count).by(1)
      end

      context "お花畑登録の処理を行った後" do
        before do
          click_button "登録する"
        end

        it "お花畑を登録すると、詳細ページに遷移すること" do
          expect(page).to have_current_path(flower_spot_path(FlowerSpot.last))
        end

        it "フラッシュメッセージが表示されること" do
          expect(page).to have_content "お花畑情報が正常に登録されました。"
        end

        it "新規作成したお花畑の「名前」が表示されること" do
          expect(page).to have_content "テストのお花畑"
        end

        it "新規作成したお花畑の写真が表示されること" do
          expect(page).to have_css("img[src*='sample.jpg']")
        end

        it "新規作成したお花畑の「住所」が表示されること" do
          expect(page).to have_content "東京都テスト区テスト1-1-1"
        end

        it "新規作成したお花畑の「見頃の時期」が表示されること" do
          expect(page).to have_content "3月"
          expect(page).to have_content "4月"
        end
      end
    end

    context "無効な場合（名前、住所、写真なしの場合）" do
      before do
        visit new_flower_spot_path
        fill_in "お花畑の名前", with: ""
        fill_in "住所", with: ""
        uncheck "3月"
        select "駐車場あり", from: "駐車場の有無"
        select "無料", from: "料金体系"
        click_button "登録する"
      end

      it "フラッシュメッセージが表示されること" do
        expect(page).to have_content "お花畑情報の登録に失敗しました。入力内容を確認してください。"
      end

      it "エラーメッセージが表示されること" do
        expect(page).to have_content "4件のエラーがあります。"
        expect(page).to have_content "お花畑の名前 は必須項目です"
        expect(page).to have_content "住所 は必須項目です"
        expect(page).to have_content "見頃の時期 を1つ以上選択してください"
        expect(page).to have_content "写真 は1枚以上必要です"
      end
    end
  end
end
