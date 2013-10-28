require 'test_helper'

class QueriesControllerTest < ActionController::TestCase
  test "should get inspector" do
    get :inspector
    assert_response :success
  end

  test "should get manager" do
    get :manager
    assert_response :success
  end

end
