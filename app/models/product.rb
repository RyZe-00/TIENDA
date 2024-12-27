class Product < ApplicationRecord
  has_many :cart_products
  has_many :carts, through: :cart_products
  has_many :order_items
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :product_reviews
  has_many :product_images
end
