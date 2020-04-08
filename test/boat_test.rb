require "minitest/autorun"
require "./lib/boat"

class BoatTest < Minitest::Test
  def setup
    @kayak = Boat.new(:kayak, 20)
  end

  def test_it_exists
    assert_instance_of Boat, @kayak
  end

  def test_it_has_readable_attributes
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
    assert_equal 0, @kayak.hours_rented
  end

  def test_it_can_add_hours
    3.times do
      @kayak.add_hour
    end
    assert_equal 3, @kayak.hours_rented
  end
end
# pry(main)> require './lib/boat'
# # => true
#
# pry(main)> require './lib/renter'
# # => true
#
# pry(main)> kayak = Boat.new(:kayak, 20)
# # => #<Boat:0x00007fceac8f0480...>
#
# pry(main)> kayak.type
# # => :kayak
#
# pry(main)> kayak.price_per_hour
# # => 20
#
# pry(main)> kayak.hours_rented
# # => 0
#
# pry(main)> kayak.add_hour
#
# pry(main)> kayak.add_hour
#
# pry(main)> kayak.add_hour
#
# pry(main)> kayak.hours_rented
