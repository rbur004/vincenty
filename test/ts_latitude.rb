require 'bundler/setup'
require 'minitest/autorun'
require 'vincenty'

class TestLatitude < Minitest::Test

  def test_creation
    assert_in_epsilon(Latitude.new(nil), 0)
  end

  def test_strf
    assert_equal("37 01'07.5000\"S", Latitude.new("S37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"S", Latitude.new("-37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"S", Latitude.new("37 01'7.5\"S").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("N37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("37 01'7.5\"").to_s)
    assert_equal("37 01'07.5000\"N", Latitude.new("37 01'7.5\"N").to_s)
  end

  def test_to_radians
    assert_in_epsilon(Math::PI/4, Latitude.degrees(45).to_rad)
    assert_in_epsilon(Math::PI/4, Latitude.degrees(135).to_rad)
    assert_in_epsilon(-Math::PI/4, Latitude.degrees(225).to_rad)
    assert_in_epsilon(-Math::PI/4, Latitude.degrees(315).to_rad)
  end

  def test_to_degrees
    assert_in_epsilon(0, Latitude.degrees(0).to_deg)
    assert_in_epsilon(90, Latitude.degrees(90).to_deg)
    assert_in_epsilon(-90, Latitude.degrees(-90).to_deg)
    assert_in_epsilon(89, Latitude.degrees(91).to_deg)
    assert_in_epsilon(-89, Latitude.degrees(-91).to_deg)
    assert_in_epsilon(45, Latitude.degrees(135).to_deg)
    assert_in_epsilon(-45, Latitude.degrees(225).to_deg)
    assert_in_epsilon(-45, Latitude.degrees(315).to_deg)
    assert_in_epsilon(1, Latitude.degrees(179).to_deg)
    assert_in_epsilon(-1, Latitude.degrees(181).to_deg)
    assert_in_epsilon(-89, Latitude.degrees(269).to_deg)
    assert_in_epsilon(-89, Latitude.degrees(271).to_deg)
    assert_in_epsilon(89, Latitude.degrees(89).to_deg)
    assert_in_epsilon(89, Latitude.degrees(91).to_deg)
  end

  def test_wrapping
    # if we cross over the pole, make sure we calculate based on our new value
    offset = Latitude.degrees(20)
    assert_equal(true, ((Latitude.degrees(85) + offset).is_a? Latitude))
    assert_in_epsilon(75, (Latitude.degrees(85) + offset).to_deg)
    assert_equal(true, (((Latitude.degrees(85) + offset) - offset).is_a? Latitude))
    assert_in_epsilon(55, (Latitude.degrees(75) - offset).to_deg)
    assert_in_epsilon(55, ((Latitude.degrees(85) + offset) - offset).to_deg)
    assert_in_epsilon(50, ((Latitude.degrees(90) + offset) - offset).to_deg)
  end
end
