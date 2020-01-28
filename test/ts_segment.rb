require 'bundler/setup'
require 'minitest/autorun'
require 'vincenty'

class TestSegment < Minitest::Test

  def test_segment
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

    # points are on lines
    assert_equal(true, seg_n.contains?(p12))
    assert_equal(true, seg_e.contains?(p3))
    assert_equal(true, seg_s.contains?(p6))
    assert_equal(true, seg_w.contains?(p9))

    # points are not on lines
    assert_equal(false, [p3, p6, p9].map { |x| seg_n.contains?(x) }.any?)
    assert_equal(false, [p12, p6, p9].map { |x| seg_e.contains?(x) }.any?)
    assert_equal(false, [p12, p3, p9].map { |x| seg_s.contains?(x) }.any?)
    assert_equal(false, [p12, p3, p6].map { |x| seg_w.contains?(x) }.any?)

    # intersections
    assert_equal(false, Segment.new(p9, p12).intersects?(Segment.new(p6, p3)))
    assert_equal(true, Segment.new(p9, p12).intersects?(Segment.new(p6, p9)))
    assert_equal(false, seg_n.intersects?(seg_s))
    assert_equal(false, seg_e.intersects?(seg_w))
    assert_equal(true, Segment.new(p6, p12).intersects?(Segment.new(p3, p9)))
    assert_equal(false, Segment.new(p6, p0).intersects?(seg_n))

    p_int = Segment.new(p6, p12).intersection(Segment.new(p3, p9))
    assert_equal(true, p_int.distanceAndAngle(p0).distance < 0.0001)

  end
end
