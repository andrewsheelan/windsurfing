class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.sum { |item| item.quantity * item.product.price }
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product: product)

    if current_item
      new_quantity = current_item.quantity + quantity
      if new_quantity <= product.stock
        current_item.update(quantity: new_quantity)
      else
        current_item.update(quantity: product.stock)
      end
    else
      quantity = [ quantity, product.stock ].min
      cart_items.create(product: product, quantity: quantity)
    end
  end

  def remove_product(product)
    cart_items.find_by(product: product)&.destroy
  end

  def update_quantity(product, quantity)
    cart_item = cart_items.find_by(product: product)
    return unless cart_item

    if quantity <= 0
      cart_item.destroy
    elsif quantity <= product.stock
      cart_item.update(quantity: quantity)
    else
      cart_item.update(quantity: product.stock)
    end
  end
end
