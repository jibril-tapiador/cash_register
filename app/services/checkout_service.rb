class CheckoutService < ApplicationService
  attr_reader :cart, :items

  def initialize(cart)
    @cart = cart
    @items = cart.cart_items.includes(:product).each_with_object({}) do |ci, h|
      h[ci.product.sku] = { product: ci.product, quantity: ci.quantity }
    end
    load_pricing_rules
  end

  def call
    base_total = items.values.sum { |h| h[:product].price * h[:quantity] }
    total_discount = @pricing_rules.sum { |rule| rule.discount_for(items) }
    (base_total - total_discount).round(2)
  end

  private

  def load_pricing_rules
    @pricing_rules = []
    @pricing_rules << PricingRules::Bogof.new(sku: 'GR1')
    @pricing_rules << PricingRules::BulkPrice.new(sku: 'SR1', threshold: 3, new_price: 4.50)
    @pricing_rules << PricingRules::VolumeDiscount.new(sku: 'CF1', threshold: 3, discount_ratio: Rational(2, 3))
  end
end
