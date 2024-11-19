require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @product = products(:one)
    sign_in @user
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get show" do
    get product_url(@product)
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: {
        product: {
          name: @product.name,
          description: @product.description,
          price: @product.price,
          stock: @product.stock
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: {
      product: {
        name: @product.name,
        description: @product.description,
        price: @product.price,
        stock: @product.stock
      }
    }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    # Create a product without any cart items
    new_product = Product.create!(
      name: "Test Product",
      description: "Test Description",
      price: 10.99,
      stock: 5
    )

    assert_difference("Product.count", -1) do
      delete product_url(new_product)
    end

    assert_redirected_to products_url
  end
end
