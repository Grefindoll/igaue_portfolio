class FlowerSpotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_flower_spot, only: [:show, :edit]

  def index
    # これから実装するかも
  end

  def show
    # before_action でセット済み
  end

  def new
    @flower_spot = FlowerSpot.new
  end

  def create
  @flower_spot = current_user.flower_spots.build(flower_spot_params)

    if @flower_spot.save
      redirect_to flower_spot_path(@flower_spot), notice: 'お花畑情報が正常に登録されました。'
    else
      flash.now[:alert] = 'お花畑情報の登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end


  private

  def set_flower_spot
    @flower_spot = FlowerSpot.find(params[:id])
  end

  def flower_spot_params
    params.require(:flower_spot).permit(
      :name,
      :address,
      { peak_season_months: [] }, # 配列としてパラメータを受け取ることを許可
      :parking,
      :fee_type,
      :fee_detail,
      :flower_type_details,
      :official_url,
      photos: [] # Active Storageで複数ファイルを受け取る場合
    )
  end
end
