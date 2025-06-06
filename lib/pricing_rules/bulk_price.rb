module PricingRules
  class BulkPrice < BaseRule
    attr_reader :new_price

    def initialize(sku:, threshold:, new_price:)
      super(sku: sku, threshold: threshold)
      @new_price = new_price.to_d
    end

    def discount_for(items)
      entry = items[sku]
      return 0 unless entry

      quantity = entry[:quantity]
      original_price = entry[:product].price

      return 0 if quantity < threshold

      per_item_discount = (original_price - new_price)
      (per_item_discount * quantity).round(2)
    end
  end
end
