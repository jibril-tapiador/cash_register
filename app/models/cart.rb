class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product_by_sku(sku)
    with_product(sku) do |product|
      item = cart_items.find_or_initialize_by(product: product)
      item.quantity += 1
      item.save!
      item
    end
  end

  def remove_product_by_sku(sku)
    with_product(sku) do |product|
      if (item = cart_items.find_by(product: product))
        if item.quantity > 1
          item.decrement!(:quantity)
        else
          item.destroy!
        end
      end
    end
  end

  def total_price
    CheckoutService.call(self)
  end

  private

  def with_product(sku)
    product = Product.find_by!(sku: sku)
    yield(product)
  end
end
