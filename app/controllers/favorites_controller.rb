class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_flower_spot

  def create
    favorite = current_user.favorites.build(flower_spot: @flower_spot)
    if favorite.save
      redirect_to flower_spot_path(@flower_spot), notice: "#{@flower_spot.name}をお気に入り登録しました。"
    else
      redirect_to flower_spot_path(@flower_spot), alert: "お気に入り登録に失敗しました。"
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(flower_spot_id: @flower_spot.id)

    if favorite
      favorite.destroy
      redirect_to flower_spot_path(@flower_spot), notice: "#{@flower_spot.name}のお気に入りを解除しました。"
    else
      redirect_to flower_spot_path(@flower_spot), alert: "お気に入り解除に失敗しました。既にお気に入り解除されているか、権限がありません。"
    end
  end

  private

  def set_flower_spot
    @flower_spot = FlowerSpot.find(params[:flower_spot_id])
  end
end
