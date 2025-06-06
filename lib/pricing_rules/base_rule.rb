module PricingRules
  class BaseRule
    attr_reader :sku, :threshold

    def initialize(sku:, threshold: nil)
      @sku = sku
      @threshold = threshold
    end

    def discount_for(items)
      raise NotImplementedError, 'Subclasses must implement discount_for'
    end
  end
end
