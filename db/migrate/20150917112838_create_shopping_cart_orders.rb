class CreateShoppingCartOrders < ActiveRecord::Migration
  def change
    create_table :shopping_cart_orders do |t|
      t.decimal  :total_price
      t.datetime :completed_date
      t.string     :state
      t.integer    :customer_id
      t.belongs_to :delivery_method, index: true, foreign_key: true
      t.belongs_to :credit_card, index: true, foreign_key: true
      t.integer    :shipping_address_id
      t.integer    :billing_address_id
      t.string     :number
      t.belongs_to :coupon, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
