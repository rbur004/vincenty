
require_relative 'track_and_distance'
require_relative 'line'

module Vincenty

  #Holds two coordinates
  class Segment
    # @return [Coordinate]
    attr_accessor :point_a
    # @return [Coordinate]
    attr_accessor :point_b

    # Create the segment between two points
    def initialize(point_a, point_b)
      @point_a = point_a
      @point_b = point_b
    end

    # length in meters
    def length
      @point_a.distanceAndAngle(@point_b).distance
    end

    # @return [boolean] whether the line contains the point
    # @param [Coordinate] coord the point to check
    def contains?(coord)
      # special cases first
      return true if coord == @point_a
      return true if coord == @point_b

      # opposite angles to both points means we're on the line
      p = coord.distanceAndAngle(@point_a)
      r = coord.distanceAndAngle(@point_b)
      ((p.bearing.reverse.to_radians - r.bearing.to_radians).abs % (2 * Math::PI)) < 0.000001
    end

    # Whether the segments intersect
    # @return [boolean] whether the given segment intersects our segment
    # @param [Segment] seg the segment to check
    def intersects?(seg)
      return false if to_line.parallel?(seg)
      crossing = to_line.projected_intersection(seg)
      contains?(crossing) && seg.contains?(crossing)
    end

    # The point at which the segments intersect
    # @return [Coordinate] the intersection, or nil
    # @param [Segment] seg the other segment
    def intersection(seg)
      return nil unless intersects?(seg)
      to_line.projected_intersection(seg)
    end

    # @return [Line] a line object anchored at point_a
    def to_line
      Line.new(@point_a, @point_a.distanceAndAngle(@point_b).bearing)
    end

    # @return [String] a string representation of the object
    def to_s
      "(#{@point_a}, #{@point_b})"
    end

  end
end
