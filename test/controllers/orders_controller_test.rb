require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @order = orders(:one)
    sign_in @user
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get show" do
    get order_url(@order)
    assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      post orders_url, params: {
        order: {
          status: "pending",
          total: 99.99
        }
      }
    end

    assert_redirected_to order_url(Order.last)
    assert_equal "pending", Order.last.status
    assert_equal 99.99, Order.last.total
    assert_equal @user, Order.last.user
  end
end
