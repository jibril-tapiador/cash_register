require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:sku) }
  it { is_expected.to validate_presence_of(:price) }

  it { is_expected.to validate_uniqueness_of(:sku) }

  it 'has a non-negative price' do
    product = build(:product, price: -1)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include('must be greater than or equal to 0')
  end
end
