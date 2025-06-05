require 'rails_helper'

RSpec.describe CheckoutService do
  let!(:cart) { create(:cart) }
  let!(:gt)   { create(:product, :green_tea) }
  let!(:st)   { create(:product, :strawberries) }
  let!(:cf)   { create(:product, :coffee) }

  # Helper to add N items of a given SKU to the cart
  def add_items(cart, sku, count)
    count.times { cart.add_product_by_sku(sku) }
  end

  context 'without any pricing rules triggered' do
    it 'calculates sum with no discounts' do
      add_items(cart, 'GR1', 1)
      add_items(cart, 'SR1', 2)
      expected = (1 * 3.11) + (2 * 5.00)
      expect(CheckoutService.call(cart)).to eq(expected.round(2))
    end
  end

  context 'buy-one-get-one-free on Green Tea' do
    it 'gives one free when 2 purchased' do
      add_items(cart, 'GR1', 2)
      # Should be price of 1 * 3.11
      expect(CheckoutService.call(cart)).to eq(3.11)
    end

    it 'gives one free for every pair' do
      [2, 3, 4, 5].each do |quantity|
        cart = create(:cart)
        add_items(cart, 'GR1', quantity)
        free_items = quantity / 2
        paying = quantity - free_items
        expect(CheckoutService.call(cart)).to eq((paying * 3.11).round(2))
      end
    end
  end

  context 'bulk price on Strawberries' do
    it 'drops price to 4.50 if 3 or more' do
      add_items(cart, 'SR1', 3)
      expect(CheckoutService.call(cart)).to eq((3 * 4.50).round(2))
    end

    it 'does not drop price if fewer than 3' do
      add_items(cart, 'SR1', 2)
      expect(CheckoutService.call(cart)).to eq((2 * 5.00).round(2))
    end
  end

  context 'volume discount on Coffee' do
    it 'drops each coffee to 2/3 price if 3 or more' do
      add_items(cart, 'CF1', 3)
      discounted_price = (11.23 * Rational(2, 3)).round(2)
      expected = (3 * discounted_price).round(2)
      expect(CheckoutService.call(cart)).to eq(expected)
    end

    it 'does not apply discount if fewer than 3' do
      add_items(cart, 'CF1', 2)
      expect(CheckoutService.call(cart)).to eq((2 * 11.23).round(2))
    end
  end

  context 'combination of rules' do
    it 'applies multiple rules together' do
      add_items(cart, 'GR1', 2) # pay for 1 => 3.11
      add_items(cart, 'SR1', 3) # 3 * 4.50 => 13.50
      add_items(cart, 'CF1', 3) # 3 * (11.23 * 2/3 ≈ 7.49) => 22.47
      expected = 3.11 + 13.50 + 22.47
      expect(CheckoutService.call(cart)).to eq(expected.round(2))
    end
  end
end
