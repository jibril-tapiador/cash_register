module PricingRules
  class Bogof < BaseRule
    def initialize(sku:)
      super(sku: sku)
    end

    def discount_for(items)
      entry = items[sku]
      return 0 unless entry

      quantity = entry[:quantity]
      price    = entry[:product].price

      free_items = quantity / 2
      (price * free_items).round(2)
    end
  end
end
