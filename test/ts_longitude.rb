require 'bundler/setup'
require 'minitest/autorun'
require 'vincenty'

class TestLongitude < Minitest::Test

  def test_creation
    assert_in_epsilon(Longitude.new(nil), 0)
  end

  def test_strf
    assert_equal("037 01'07.5000\"W", Longitude.new("W37 01'7.5\"").to_s)
    assert_equal("037 01'07.5000\"W", Longitude.new("-37 01'7.5\"").to_s)
    assert_equal("037 01'07.5000\"W", Longitude.new("37 01'7.5\"W").to_s)
    assert_equal("037 01'07.5000\"E", Longitude.new("E37 01'7.5\"").to_s)
    assert_equal("037 01'07.5000\"E", Longitude.new("37 01'7.5\"").to_s)
    assert_equal("037 01'07.5000\"E", Longitude.new("37 01'7.5\"E").to_s)
  end

  def test_to_radians
    assert_in_epsilon(Math::PI/4, Longitude.degrees(45).to_rad)
    assert_in_epsilon(3*Math::PI/4, Longitude.degrees(135).to_rad)
    assert_in_epsilon(-3*Math::PI/4, Longitude.degrees(225).to_rad)
    assert_in_epsilon(-Math::PI/4, Longitude.degrees(315).to_rad)
  end

  def test_to_degrees
    assert_in_epsilon(45, Longitude.degrees(45).to_deg)
    assert_in_epsilon(135, Longitude.degrees(135).to_deg)
    assert_in_epsilon(-135, Longitude.degrees(225).to_deg)
    assert_in_epsilon(-45, Longitude.degrees(315).to_deg)
  end
end
