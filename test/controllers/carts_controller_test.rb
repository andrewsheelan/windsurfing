require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get show" do
    get cart_url
    assert_response :success
  end

  test "should clear cart" do
    delete cart_url
    assert_redirected_to cart_url
    assert_equal 0, @user.cart.cart_items.count
  end
end
