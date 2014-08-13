require 'test/unit'
require 'vincenty.rb'

class TestAngle< Test::Unit::TestCase
  #test Coordinate
  def test_coordinate
    c = Coordinate.new(-36.9923293459124, 174.485341187381,13.5)
    ca = c.to_ary
    assert_equal(-36.9923293459124, ca[0].to_deg)
    assert_equal(174.485341187381, ca[1].to_deg)
    assert_equal(13.5, ca[2])
    ch = c.to_hash
    assert_equal(-36.9923293459124, ch[:latitude].to_deg)
    assert_equal(174.485341187381, ch[:longitude].to_deg)
    assert_equal(13.5, ch[:altitude])
    assert_equal("36 59'32.3856\"S  174 29'07.2283\"E 13.5m", c.to_s)
  end
end