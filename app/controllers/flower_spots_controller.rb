class FlowerSpotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_flower_spot, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user_or_admin, only: [:edit, :update, :destroy]

  def index
    @flower_spots = FlowerSpot.order(created_at: :desc)
  end

  def show
    # @flower_spot は set_flower_spot でセット済み
  end

  def new
    @flower_spot = FlowerSpot.new
  end

  def edit
    # before_action でset_flower_spot済み。
    # ensure_correct_user_or_admin で権限チェック済み
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

  def update
    # before_action でset_flower_spot済み。
    # ensure_correct_user_or_admin で権限チェック済み
    if @flower_spot.update(flower_spot_params)
      redirect_to @flower_spot, notice: 'お花畑情報が正常に更新されました。'
    else
      flash.now[:alert] = 'お花畑情報の更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # before_action でset_flower_spot済み。
    @flower_spot.destroy
    redirect_to root_path, notice: 'お花畑情報を削除しました。', status: :see_other
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
      flower_photos: []
    )
  end

  def ensure_correct_user_or_admin
    unless @flower_spot.user == current_user || current_user&.admin?
      redirect_to root_path, alert: '権限がありません。'
    end
  end
end
