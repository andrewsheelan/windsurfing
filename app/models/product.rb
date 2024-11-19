class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def image_as_thumbnail
    return unless image.attached?

    image.variant(resize_to_limit: [ 800, 800 ]).processed
  end
end
