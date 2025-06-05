FactoryBot.define do
  factory :product do
    sequence(:sku) { |n| "SKU#{n}" }
    sequence(:name) { |n| "Product #{n}" }
    price { 1.00 }

    trait :green_tea do
      name { 'Green Tea' }
      sku  { 'GR1' }
      price { 3.11 }
    end

    trait :strawberries do
      name { 'Strawberries' }
      sku  { 'SR1' }
      price { 5.00 }
    end

    trait :coffee do
      name { 'Coffee' }
      sku  { 'CF1' }
      price { 11.23 }
    end
  end
end
