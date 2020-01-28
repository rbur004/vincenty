require 'bundler/setup'
require 'minitest/autorun'
require 'vincenty'

class TestLine < Minitest::Test

  def test_line
    # clock points, 1 = NE, 4 = SE, 7 = SW, 10 = NW
    #
    # 10    12    1
    #
    # 9     0     3
    #
    # 7     6     4
    #
    p0  = Coordinate.new(1.500, 1.500)

    p1  = Coordinate.new(1.501, 1.501)
    p3  = Coordinate.new(1.500, 1.501)
    p4  = Coordinate.new(1.499, 1.501)
    p6  = Coordinate.new(1.499, 1.500)
    p7  = Coordinate.new(1.499, 1.499)
    p9  = Coordinate.new(1.500, 1.499)
    p10 = Coordinate.new(1.501, 1.499)
    p12 = Coordinate.new(1.501, 1.500)

    seg_n = Segment.new(p10, p1)
    seg_e = Segment.new(p1, p4)
    seg_s = Segment.new(p4, p7)
    seg_w = Segment.new(p7, p10)

    # intersections
    assert_equal(false, Segment.new(p9, p12).to_line.intersects?(Segment.new(p6, p3)))
    assert_equal(true, Segment.new(p9, p12).to_line.intersects?(Segment.new(p6, p9)))
    assert_equal(false, seg_n.to_line.intersects?(seg_s))
    assert_equal(false, seg_e.to_line.intersects?(seg_w))
    assert_equal(true, Segment.new(p6, p12).to_line.intersects?(Segment.new(p3, p9)))

    p_int = Segment.new(p6, p12).to_line.intersection(Segment.new(p3, p9))
    assert_equal(true, p_int.distanceAndAngle(p0).distance < 0.0001)

    # projected intersections
    # LHS points to RHS
    p_int = Segment.new(p6, p0).to_line.projected_intersection(seg_n)
    assert_equal(true, p_int.distanceAndAngle(p12).distance < 0.0001)

    # RHS points to LHS
    p_int = seg_n.to_line.projected_intersection(Segment.new(p6, p0))
    assert_equal(true, p_int.distanceAndAngle(p12).distance < 0.0001)

    # regular intersections
    # LHS points to RHS
    p_int = Segment.new(p6, p0).to_line.intersection(seg_n)
    assert_equal(true, p_int.distanceAndAngle(p12).distance < 0.0001)

    # RHS does not cross LHS
    p_int = seg_n.to_line.intersection(Segment.new(p6, p0))
    assert_nil(p_int)
    p_int = seg_n.to_line.intersection(Segment.new(p0, p6))
    assert_nil(p_int)

    # regular intersections
    # LHS points to RHS
    p_int = Segment.new(p0, p6).to_line.intersection(seg_n) # reverse direction
    assert_equal(true, p_int.distanceAndAngle(p12).distance < 0.0001)
  end
end
