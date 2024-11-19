class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  STATUSES = %w[pending processing shipped delivered cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
end
