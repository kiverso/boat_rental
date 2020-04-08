require "minitest/autorun"
require "./lib/renter"
require "./lib/boat"
require "./lib/dock"

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists
    assert_instance_of Dock, @dock
  end

  def test_it_has_readable_attributes
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_it_can_rent_boats
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    expected = {
      @kayak_1 => @patrick,
      @kayak_2 => @patrick,
      @sup_1 => @eugene
      }
    assert_equal expected, @dock.rental_log
  end

  def test_it_can_charge_for_boats
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @kayak_1.add_hour
    @kayak_1.add_hour
    expected = {
      :card_number=> "4242424242424242",
      :amount => 40
      }
    assert_equal expected, @dock.charge(@kayak_1)
  end

  def test_it_does_not_charge_for_hours_over_maximum
    @dock.rent(@sup_1, @eugene)
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    expected = {
      :card_number => "1313131313131313",
      :amount => 45
      }
    assert_equal expected, @dock.charge(@sup_1)
  end

  def test_it_logs_hours
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal 2, @kayak_1.hours_rented
    assert_equal 1, @canoe.hours_rented
  end

  def test_it_returns_boats
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    expected = {@kayak_1 => @patrick,
                @kayak_2 => @patrick}
    assert_equal expected, @dock.rental_log
    @dock.return(@kayak_1)
    expected_new = {@kayak_2 => @patrick}
    assert_equal expected_new, @dock.rental_log
  end

  def test_it_gets_revenue_when_boat_is_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal 0, @dock.revenue
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    assert_equal 105, @dock.revenue
  end

  def test_it_does_not_generate_revenue_for_hours_over_max
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)
    assert_equal 195, @dock.revenue
  end
end


# pry(main)> dock.rent(canoe, patrick)
#
# # kayak_1, kayak_2, and canoe are rented an additional hour
# pry(main)> dock.log_hour
#
# # Revenue should not be generated until boats are returned
# pry(main)> dock.revenue
# # => 0
#
# pry(main)> dock.return(kayak_1)
#
# pry(main)> dock.return(kayak_2)
#
# pry(main)> dock.return(canoe)
#
# # Revenue thus far
# pry(main)> dock.revenue
# # => 105
#
# # Rent Boats out to a second Renter
# pry(main)> dock.rent(sup_1, eugene)
#
# pry(main)> dock.rent(sup_2, eugene)
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# # Any hours rented past the max rental time don't factor into revenue
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.return(sup_1)
#
# pry(main)> dock.return(sup_2)
#
# # Total revenue
# pry(main)> dock.revenue
# # => 195
# ```
