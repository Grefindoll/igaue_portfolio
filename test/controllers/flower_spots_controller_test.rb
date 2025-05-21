require "test_helper"

class FlowerSpotsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get flower_spots_new_url
    assert_response :success
  end
end
