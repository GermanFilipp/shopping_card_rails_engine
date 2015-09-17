module ShoppingCart
  class CreditCard < ActiveRecord::Base
    has_many   :orders


    validates  :number, :CVV, :expiration_month, :expiration_year,  presence: true

    validates :number, format: { with: /[0-9]{4}\-[0-9]{4}\-[0-9]{4}\-[0-9]{4}/,
                                 message:  "format should be like '1234-1234-1234-1234'"}, presence: true
    validates :CVV, format: { with: /[0-9]{3}/,
                              message:  "should be like '123' "}, presence: true


    def display_number
      '****-****-****-'+number.to_s.slice(-4..-1)
    end

    def display_month
      expiration_month.to_s.rjust(2, '0')
    end

    def month_list
      (1..12).map{|month| [month.to_s.rjust(2, '0'), month]}
    end

    def year_list
      first_year = Time.zone.now.year
      last_year = first_year+7
      (first_year..last_year).map{|year| [year, year]}
    end

  end
end
