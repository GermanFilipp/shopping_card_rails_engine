module ShoppingCart
  class Country < ActiveRecord::Base
    has_many :addresses

    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: false }
  end
end
