module ShoppingCart
  class Address < ActiveRecord::Base
    validates  :address,:first_name,:last_name, :city, :phone, :country,:zipcode,  presence: true
  end
end
