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
end

# pry(main)> kayak_1.add_hour
#
# pry(main)> kayak_1.add_hour
#
# pry(main)> dock.charge(kayak_1)
# # =>
# # {
# #   :card_number => "4242424242424242",
# #   :amount => 40
# # }
#
# pry(main)> sup_1.add_hour
#
# pry(main)> sup_1.add_hour
#
# pry(main)> sup_1.add_hour
#
# # Any hours past the max rental time should not count
# pry(main)> sup_1.add_hour
#
# pry(main)> sup_1.add_hour
#
# pry(main)> dock.charge(sup_1)
# # =>
# # {
# #   :card_number => "1313131313131313",
# #   :amount => 45
# # }
