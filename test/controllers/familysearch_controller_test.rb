require 'test_helper'

class FamilysearchControllerTest < ActionController::TestCase
  test "should get auth" do
    get :auth
    assert_response :success
  end

  test "should get post_pic" do
    get :post_pic
    assert_response :success
  end

end
