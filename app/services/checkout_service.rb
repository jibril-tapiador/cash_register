class CheckoutService < ApplicationService
  PRICING_RULES = [
    { klass: PricingRules::Bogof, args: { sku: 'GR1' } },
    { klass: PricingRules::BulkPrice, args: { sku: 'SR1', threshold: 3, new_price: 4.50 } },
    { klass: PricingRules::VolumeDiscount, args: { sku: 'CF1', threshold: 3, discount_ratio: Rational(2, 3) } }
  ].freeze

  attr_reader :cart, :items, :pricing_rules

  def initialize(cart)
    @cart = cart
    @items = build_items
    @pricing_rules = build_pricing_rules
  end

  def call
    (base_total - total_discount).round(2)
  end

  private

  def base_total
    items.values.sum { |entry| entry[:product].price * entry[:quantity] }
  end

  def total_discount
    pricing_rules.sum { |rule| rule.discount_for(items) }
  end

  def build_items
    cart.cart_items.includes(:product).each_with_object({}) do |cart_item, hash|
      hash[cart_item.product.sku] = {
        product: cart_item.product,
        quantity: cart_item.quantity
      }
    end
  end

  def build_pricing_rules
    PRICING_RULES.map { |rule| rule[:klass].new(**rule[:args]) }
  end
end
