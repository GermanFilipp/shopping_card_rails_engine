class CreateShoppingCartOrderItems < ActiveRecord::Migration
  def change
    create_table :shopping_cart_order_items do |t|
      t.decimal :price, default:0
      t.integer :quantity
      t.integer :product_id
      t.belongs_to :orders, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
