module ShoppingCart
  class DeliveryMethod < ActiveRecord::Base
    STATE = %w(inactive, active)
    validates :name, :price,:state, presence: true
    validates :name, uniqueness: true


    enum state: STATE
    scope :active, -> {where state: 1}
    def state_enum
      STATE
    end
  end
end
