class FlowerSpotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @flower_spot = FlowerSpot.new
  end
end
