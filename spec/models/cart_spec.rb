require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:cart) { create(:cart) }
  let!(:green_tea) { create(:product, :green_tea) }

  describe '#add_product_by_sku' do
    it 'creates a new cart_item if none exists' do
      expect {
        cart.add_product_by_sku('GR1')
      }.to change { cart.cart_items.count }.by(1)

      item = cart.cart_items.last
      expect(item.product).to eq(green_tea)
      expect(item.quantity).to eq(1)
    end

    it 'increments quantity if already present' do
      cart.add_product_by_sku('GR1')
      expect {
        cart.add_product_by_sku('GR1')
      }.not_to change { cart.cart_items.count }

      expect(cart.cart_items.find_by(product: green_tea).quantity).to eq(2)
    end

    it 'raises if SKU not found' do
      expect {
        cart.add_product_by_sku('UNKNOWN')
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#remove_product_by_sku' do
    before do
      cart.add_product_by_sku('GR1')
      cart.add_product_by_sku('GR1')
    end

    it 'decrements quantity if >1' do
      expect {
        cart.remove_product_by_sku('GR1')
      }.not_to change { cart.cart_items.count }

      expect(cart.cart_items.find_by(product: green_tea).quantity).to eq(1)
    end

    it 'removes cart_item if quantity == 1' do
      cart.remove_product_by_sku('GR1') # now quantity 1
      expect {
        cart.remove_product_by_sku('GR1')
      }.to change { cart.cart_items.count }.by(-1)
    end

    it 'does nothing if SKU not in cart' do
      expect {
        cart.remove_product_by_sku('UNKNOWN')
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
