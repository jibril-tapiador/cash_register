module PricingRules
  class VolumeDiscount < BaseRule
    attr_reader :discount_ratio

    def initialize(sku:, threshold:, discount_ratio:)
      super(sku: sku, threshold: threshold)
      @discount_ratio = discount_ratio
    end

    def discount_for(items)
      entry = items[sku]
      return 0 unless entry

      quantity       = entry[:quantity]
      original_price = entry[:product].price

      return 0 if quantity < threshold

      discounted_price = (original_price * discount_ratio).round(2)
      per_item_discount = (original_price - discounted_price)
      (per_item_discount * quantity).round(2)
    end
  end
end
