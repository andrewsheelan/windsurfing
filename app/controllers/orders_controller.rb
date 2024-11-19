class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders
  end

  def show
  end

  def create
    @order = current_user.orders.build(order_params)
    
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :total)
  end
end
