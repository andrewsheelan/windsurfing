class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [ :update, :destroy ]

  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i || 1

    if quantity <= 0 || quantity > product.stock
      respond_to do |format|
        format.html { redirect_to product_path(product), alert: "Invalid quantity selected." }
        format.json { render json: { error: "Invalid quantity selected." }, status: :unprocessable_entity }
      end
      return
    end

    @cart.add_product(product, quantity)

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Product added to cart." }
      format.json {
        render json: {
          message: "Product added to cart successfully.",
          cart_total: helpers.number_to_currency(@cart.total_price),
          cart_items_count: @cart.total_items
        }
      }
    end
  end

  def update
    quantity = params[:quantity].to_i

    if quantity <= 0
      @cart_item.destroy
    else
      @cart_item.update(quantity: quantity)
    end

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Cart updated." }
      format.json {
        render json: {
          cart_total: helpers.number_to_currency(@cart.total_price),
          item_total: helpers.number_to_currency(@cart_item.product.price * @cart_item.quantity),
          cart_items_count: @cart.total_items
        }
      }
    end
  end

  def destroy
    @cart_item.destroy

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
      format.json { head :no_content }
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end
end
