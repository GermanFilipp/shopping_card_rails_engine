module ShoppingCart
  class Ability
    include ::CanCan::Ability

    def initialize(customer)
      if user.is_admin?
        can :manage, :all
      else
        can :read, DeliveryMethod
        can :read, Order, customer: customer
        can [:index,:destroy,:create,:update,:destroy_all], OrderItem
        can :manage,Address,customer:customer
        can :manage,CreditCard,customer:customer

      end

    end
  end
end
