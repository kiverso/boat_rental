class Dock
  attr_reader :name, :max_rental_time, :rental_log
  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
  end

  def rent(boat, renter)
    rental_log[boat] = renter
  end
  def charge(boat)
    bill = {}
    if boat.hours_rented > @max_rental_time
      amount = @max_rental_time * boat.price_per_hour
    else
      amount = boat.hours_rented * boat.price_per_hour
    end
    renter = @rental_log[boat]
    bill[:card_number] = renter.credit_card_number
    bill[:amount] = amount
    bill
  end
end
