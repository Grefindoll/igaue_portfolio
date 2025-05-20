class HomeController < ApplicationController
  def index
    flower_spots_on_map = FlowerSpot.where.not(latitude: nil, longitude: nil)

    flower_spots_data_for_js = flower_spots_on_map.map do |spot|
      {
        id: spot.id,
        name: spot.name,
        latitude: spot.latitude,
        longitude: spot.longitude,
        show_path: flower_spot_path(spot),
        peak_season_months: spot.peak_season_months,
        parking: spot.parking,
        fee_type: spot.fee_type
      }
    end
    @flower_spots_for_map_json = flower_spots_data_for_js.to_json
  end
end
