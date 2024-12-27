class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  def total_price
    cart_products.sum { |cart_product| cart_product.product.price * cart_product.quantity }
  end
end
