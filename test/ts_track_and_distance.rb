require 'bundler/setup'
require 'minitest/autorun'
require 'vincenty'

class TestTrackAndDistance < Minitest::Test

  #test TrackAndDistance
  def test_track_and_distance
    assert_equal("140 14'10.0000\" 12.0m", TrackAndDistance.new(Angle.new("320,14,10").reverse, 12.0).to_s)
    assert_equal("215 03'00.0000\" 19.73m", TrackAndDistance.new("215,3,0", 19.73 ).to_s)
    a = TrackAndDistance.new("215,3,0", 19.73 ).to_ary
    assert_equal("215 03'00.0000\"", a[0].strf)
    assert_equal("19.73", a[1].to_s)
    a = TrackAndDistance.new("215,3,0", 19.73 ).to_hash
    assert_equal("215 03'00.0000\"", a[:bearing].strf)
    assert_equal("19.73", a[:distance].to_s)

    # clock points, 1 = NE, 4 = SE, 7 = SW, 10 = NW
    p0  = Coordinate.new(1.500, 1.500)
    p1  = Coordinate.new(1.501, 1.501)
    p4  = Coordinate.new(1.499, 1.501)
    p7  = Coordinate.new(1.499, 1.499)
    p10 = Coordinate.new(1.501, 1.499)

    assert_equal(true, 0 < p0.distanceAndAngle(p1).northings)
    assert_equal(true, 0 < p0.distanceAndAngle(p1).eastings)

    assert_equal(false, 0 < p0.distanceAndAngle(p4).northings)
    assert_equal(true, 0 < p0.distanceAndAngle(p4).eastings)

    assert_equal(false, 0 < p0.distanceAndAngle(p7).northings)
    assert_equal(false, 0 < p0.distanceAndAngle(p7).eastings)

    assert_equal(true, 0 < p0.distanceAndAngle(p10).northings)
    assert_equal(false, 0 < p0.distanceAndAngle(p10).eastings)

    # creation using XY
    assert_equal(5, TrackAndDistance.from_xy(3, 4).distance)
    assert_equal(45, TrackAndDistance.from_xy(1, 1).bearing.to_degrees % 360)
    assert_equal(135, TrackAndDistance.from_xy(1, -1).bearing.to_degrees % 360)
    assert_equal(225, TrackAndDistance.from_xy(-1, -1).bearing.to_degrees % 360)
    assert_equal(315, TrackAndDistance.from_xy(-1, 1).bearing.to_degrees % 360)

    daa = p0.distanceAndAngle(p1)
    assert_in_epsilon(daa.distance, Math.hypot(daa.northings, daa.eastings))

  end
end
