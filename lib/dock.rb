class Dock
  attr_reader :name, :max_rental_time, :rental_log, :revenue
  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
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

  def log_hour
    @rental_log.keys.each do |boat|
      boat.add_hour
    end
  end

  def return(boat)
    rental_revenue = charge(boat)[:amount]
    @rental_log.delete(boat)
    @revenue += rental_revenue
  end
end
