module ShoppingCart
  class Order < ActiveRecord::Base
    include AASM
    belongs_to :credit_card
    belongs_to :shipping_address, class_name: "Address",  autosave: true
    belongs_to :billing_address, class_name: "Address", autosave: true
    belongs_to :delivery_method
    belongs_to :coupon
    has_many   :order_items

    STATE_IN_PROGRESS = 'in progress'
    scope :already_completed, -> {where.not(state: STATE_IN_PROGRESS)}

    def self.all_completed_orders
      self.already_completed.order(state: :asc, completed_date: :desc)
    end

    validates   :state, presence: true
    validates_associated :billing_address, :shipping_address, :credit_card, :delivery_method
    enum state: {
             in_progress: "in progress",
             in_queue: "in queue",
             in_delivery: "in delivery",
             delivered: "delivered",
             canceled:  "canceled",
         }
    aasm column: :state, :enum => true do
      state :in_progress, :initial => true
      state :in_queue
      state :in_delivery
      state :delivered
      state :canceled

      event :checkout, :before => :set_completed_date, :after => :update_sold_count do
        transitions :from => :in_progress, :to => :in_queue
      end

      event :confirm do
        transitions :from => :in_queue, :to => :in_delivery
      end

      event :deliver do
        transitions :from => :in_delivery, :to => :delivered
      end

      event :cancel do
        transitions :from => :in_queue, :to => :canceled
      end


    end

    after_create do
      self.update(number: "R"+rand(100000000..999999999).to_s)
    end

    def total_items
      @total_items = self.order_items.sum(:quantity) if @total_items.nil?
      @total_items
    end

    def add_book(book,quantity)
      order = self
      order_item = order.order_items.find_by(:book => book)
      if order_item.nil?
        order_item = OrderItem.new({:book => book, :order => order, :price => book.price, :quantity => quantity})
      else
        order_item.quantity += quantity
      end
      order_item.save
    end

    def total_price
      items_price = self.order_items.map {|item| item.quantity*item.price}
      price = items_price.inject(&:+) || 0
      unless self.coupon.blank?
        self.total_price =  price - self.coupon.price
      else
        self.total_price =  price
      end

    end

    def set_completed_date
      self.completed_date = Time.zone.now
    end

    def save_credit_card(credit_card_params)
      credit_card = self.credit_card

      if credit_card.nil?
        credit_card = CreditCard.find_or_create_by(credit_card_params)
        credit_card.valid? && self.update(:credit_card => credit_card)
      else
        credit_card.update(credit_card_params)
      end
    end

    def books
      self.order_items.includes(:book).references(:book)
    end

    def update_sold_count
      return false if self.state  == STATE_IN_PROGRESS
      self.order_items.each do |order_item|
        Book.where(id: order_item.book_id).update_all("sold_count = sold_count + #{order_item.quantity}")
      end
    end

    def save_address(address_params= {})
      address_type = (address_params[:type]+'_address').to_sym
      address_params.delete(:type)
      address = self.send(address_type)
      if (address.nil? || self.billing_address_id == self.shipping_address_id)
        address = Address.find_or_create_by(address_params)
        address.valid? && self.update(address_type => address)
      else
        address.update(address_params)
      end
    end



  end
end
