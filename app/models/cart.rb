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

  # Returns a hash of { "SKU1" => quantity1, "SKU2" => quantity2, … }
  def items_hash
    cart_items.includes(:product).map { |ci| [ci.product.sku, ci.quantity] }.to_h
  end

  def total_price
    CheckoutService.new(self).total
  end

  private

  def with_product(sku)
    product = Product.find_by!(sku: sku)
    yield(product)
  end
end
