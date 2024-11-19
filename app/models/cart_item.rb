class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: ->(item) { item.product.stock }
  }

  validate :product_must_be_in_stock

  before_save :ensure_quantity_within_stock

  def total_price
    quantity * product.price
  end

  private

  def product_must_be_in_stock
    if product.present? && product.stock == 0
      errors.add(:base, "Product is out of stock")
    end
  end

  def ensure_quantity_within_stock
    self.quantity = [ quantity, product.stock ].min if product.present?
  end
end
