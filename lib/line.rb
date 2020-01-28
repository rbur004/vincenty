require_relative 'angle'

module Vincenty

  # A bearing rooted at a particular coordinate point
  class Line
    #Holds a bearing and an origin

    # @return [Coordinate]
    attr_accessor :origin

    # @return [Angle]
    attr_accessor :bearing

    def initialize(origin, bearing)
      @origin = origin
      @bearing = bearing
    end

    # Whether the lines are parallel
    # @return [boolean] whether the given segment is parallel
    # @param [Segment] seg the segment to check
    def parallel?(seg)
      ((bearing - seg.to_line.bearing).abs % Math::PI) < 0.000001
    end

    # Whether the line would intersect the segment
    # @return [boolean] whether the given segment intersects our segment
    # @param [Segment] seg the segment to check
    def intersects?(seg)
      return false if parallel?(seg)
      crossing = projected_intersection(seg)
      seg.contains?(crossing)
    end

    # The point at which the line intersects the segment
    # @return [Coordinate] the intersection, or nil
    # @param [Segment] seg
    def intersection(seg)
      return nil unless intersects?(seg)
      projected_intersection(seg)
    end

    # The point at which the line would intersect the segment
    # @return [Coordinate] the intersection
    # @param [Segment] seg
    def projected_intersection(seg)
      return seg.point_a if seg.point_a == @origin
      return seg.point_b if seg.point_b == @origin

      # https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
      # get ready

      # assume point A of this segment is 0, 0.  Then add the result back to point A
      p1x = 0

      p1y = 0
      p2 = TrackAndDistance.new(@bearing, 1)
      p3 = @origin.distanceAndAngle(seg.point_a)
      p4 = @origin.distanceAndAngle(seg.point_b)

      px = (((p1x * p2.y - p1y * p2.x) * (p3.x - p4.x) - (p1x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) /
        ((p1x - p2.x) * (p3.y - p4.y) - (p1y - p2.y) * (p3.x - p4.x)))

      py = (((p1x * p2.y - p1y * p2.x) * (p3.y - p4.y) - (p1y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) /
        ((p1x - p2.x) * (p3.y - p4.y) - (p1y - p2.y) * (p3.x - p4.x)))

      @origin.destination(TrackAndDistance.from_xy(px, py))
    end

  end
end
