class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user, only: [:show, :edit, :update, :favorites]
  before_action :ensure_correct_user_or_admin, only: [:edit, :update]

  def show
    # @user は set_user でセット済み
  end

  def edit
    # @user は set_user でセット済み
  end

  def update
    # @user は set_user でセット済み
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました。"
      redirect_to user_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def favorites
    # @user は set_user でセット済み
    @favorite_flower_spots = @user.favorite_flower_spots.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:username, :introduction, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user_or_admin
    unless @user == current_user || current_user&.admin?
      redirect_to root_path, alert: '権限がありません。'
    end
  end
end
