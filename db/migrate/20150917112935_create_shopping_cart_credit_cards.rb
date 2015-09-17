class CreateShoppingCartCreditCards < ActiveRecord::Migration
  def change
    create_table :shopping_cart_credit_cards do |t|
      t.string :number
      t.string :CVV
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
