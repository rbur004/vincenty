require 'test/unit'
require 'vincenty.rb'

class TestAngle< Test::Unit::TestCase
  #test TrackAndDistance
  def test_track_and_distance
    assert_equal("140°14′10.0000″ 12.0m", TrackAndDistance.new(Angle.new("320,14,10").reverse, 12.0).to_s)
    assert_equal("215°03′00.0000″ 19.73m", TrackAndDistance.new("215,3,0", 19.73 ).to_s)
    a = TrackAndDistance.new("215,3,0", 19.73 ).to_ary
    assert_equal("215°03′00.0000″", a[0].strf)
    assert_equal("19.73", a[1].to_s)
    a = TrackAndDistance.new("215,3,0", 19.73 ).to_hash
    assert_equal("215°03′00.0000″", a[:bearing].strf)
    assert_equal("19.73", a[:distance].to_s)
  end
end
