class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string  :name,  null: false
      t.string  :sku,   null: false, index: { unique: true }
      t.decimal :price, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
