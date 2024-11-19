require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @product = products(:one)
    @product.update!(stock: 5)  # Ensure enough stock for tests
    @cart = @user.cart || @user.create_cart
    @cart_item = @cart.cart_items.create!(
      product: @product,
      quantity: 1
    )
    sign_in @user
  end

  test "should create cart_item" do
    product = products(:two)  # Use a different product
    product.update!(stock: 5)  # Ensure enough stock
    assert_difference("CartItem.count") do
      post cart_items_url, params: { 
        product_id: product.id,
        quantity: 1
      }
    end

    assert_redirected_to cart_path
  end

  test "should update cart_item" do
    assert_changes -> { @cart_item.reload.quantity }, from: 1, to: 2 do
      patch cart_item_url(@cart_item), 
        params: { quantity: 2 },
        as: :json

      assert_response :success
      @cart_item.reload
    end
  end

  test "should destroy cart_item" do
    assert_difference("CartItem.count", -1) do
      delete cart_item_url(@cart_item)
    end

    assert_redirected_to cart_path
  end

  test "should handle invalid quantity" do
    post cart_items_url, 
      params: { 
        product_id: @product.id,
        quantity: @product.stock + 1
      },
      as: :json
    
    assert_response :unprocessable_entity
    assert_equal "Invalid quantity selected.", JSON.parse(response.body)["error"]
  end

  test "should handle out of stock products" do
    @product.update(stock: 0)
    
    post cart_items_url, 
      params: { 
        product_id: @product.id,
        quantity: 1
      },
      as: :json
    
    assert_response :unprocessable_entity
    assert_equal "Invalid quantity selected.", JSON.parse(response.body)["error"]
  end

  test "should handle quantity exceeding stock" do
    patch cart_item_url(@cart_item),
      params: { quantity: @product.stock + 1 },
      as: :json

    assert_response :unprocessable_entity
    assert_equal "Quantity cannot exceed available stock.", JSON.parse(response.body)["error"]
  end
end
