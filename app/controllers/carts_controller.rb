class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def update
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    @cart.update_quantity(product, quantity)

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Cart updated successfully." }
      format.json { render json: {
        total_price: helpers.number_to_currency(@cart.total_price),
        total_items: @cart.total_items,
        item_price: helpers.number_to_currency(product.price * quantity)
      } }
    end
  end

  def destroy
    @cart.cart_items.destroy_all

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Cart cleared successfully." }
      format.json { head :no_content }
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
