require 'test_helper'

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get checkouts_index_url
    assert_response :success
  end

end
