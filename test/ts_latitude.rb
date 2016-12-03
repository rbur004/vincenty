require 'test/unit'
require_relative '../lib/vincenty.rb'

class TestLatitude< Test::Unit::TestCase
  def test_strf
    assert_equal("37 01'07.5000\"S", Latitude.new("S37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"S", Latitude.new("-37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"S", Latitude.new("37 01'7.5\"S").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("N37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("37 01'7.5\"N").to_s)
  end
  def test_to_radians
    assert_equal(Math::PI/4, Latitude.degrees(45).to_rad)
    assert_equal(Math::PI/4, Latitude.degrees(135).to_rad)
    assert_equal(-Math::PI/4, Latitude.degrees(225).to_rad)
    assert_equal(-Math::PI/4, Latitude.degrees(315).to_rad)
  end
  def test_to_degrees
    assert_equal(45, Latitude.degrees(45).to_deg)
    assert_equal(45, Latitude.degrees(135).to_deg)
    assert_equal(-45, Latitude.degrees(225).to_deg)
    assert_equal(-45, Latitude.degrees(315).to_deg)
    assert_equal(1, Latitude.degrees(179).to_deg)
    assert_equal(-1, Latitude.degrees(181).to_deg)
    assert_equal(-89, Latitude.degrees(269).to_deg)
    assert_equal(-89, Latitude.degrees(271).to_deg)
    assert_equal(89, Latitude.degrees(89).to_deg)
    assert_equal(89, Latitude.degrees(91).to_deg)
  end
end
