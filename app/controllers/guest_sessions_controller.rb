class GuestSessionsController < ApplicationController
  def create
    guest_user = User.find_by(email: "guest@example.com")

    if guest_user
      sign_in guest_user # Deviseのヘルパーメソッドでゲストユーザーをログインさせる
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
    else
      redirect_to new_user_session_path, alert: 'ゲストユーザーの準備ができていません。管理者にお問い合わせください。'
    end
  end
end
