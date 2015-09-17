class CreateShoppingCartCoupons < ActiveRecord::Migration
  def change
    create_table :shopping_cart_coupons do |t|
      t.string :number
      t.decimal :price, default: 0

      t.timestamps null: false
    end
  end
end
