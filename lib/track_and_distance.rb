require_relative 'angle.rb'

# Holds a bearing and distance
class TrackAndDistance
  # @return [Angle]
  attr_accessor :bearing
  # @return [Float]
  attr_accessor :distance

  # @param [String, Numeric, #to_radian, #to_f] Bearing can be a String or Numeric or any object with to_radians and to_f
  # @param [Numeric] distance
  # @param [true,false, :radians] radians Bearing is in degrees unless radians == true (or set to :radians).
  def initialize(bearing, distance, radians = false)
    @bearing = Angle.new(bearing, radians)
    @distance = distance
  end

  # format string fmt is currently just for the bearing angle.
  # Need to change this to include the distance is single format string.
  # @return [String] Bearing angle and distance in meters.
  # @param [String] fmt Optional format string passed to Coordinate#strf
  def to_s(fmt = nil)
    if fmt
      # needs work to include distance as well as angle fmt.
      return "#{@bearing.strf(fmt)} #{distance.round(4)}m"
    else
      return "#{@bearing.strf} #{distance.round(4)}m"
    end
  end

  # @return [Array] with members bearing and distance.
  def to_ary
    return [ @bearing, @distance ]
  end

  # @return [Hash] with keys :bearing and :distance
  def to_hash
    return { bearing: @bearing, distance: @distance }
  end

  alias deconstruct_keys to_hash
  alias deconstruct to_ary
end
