require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it 'is valid with valid attributes' do
    ci = build(:cart_item)
    expect(ci).to be_valid
  end

  it 'is invalid with quantity ≤ 0' do
    ci = build(:cart_item, quantity: 0)
    expect(ci).not_to be_valid
    expect(ci.errors[:quantity]).to include('must be greater than 0')
  end

  it 'belongs to a cart and product' do
    ci = create(:cart_item)
    expect(ci.cart).to be_a(Cart)
    expect(ci.product).to be_a(Product)
  end
end
