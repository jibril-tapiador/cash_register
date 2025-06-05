class Product < ApplicationRecord
  validates :name, :sku, :price, presence: true
  validates :sku, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  has_many :cart_items, dependent: :destroy
end
