require_relative 'angle.rb'

# Subclass of Angle to add in special treatment of to_d, to_r , to_s
# Latitude degrees are between -PI and PI, South to North (+/- 90 degrees)
class Latitude < Angle
  # @return [Float] angle as degrees in range -90 and 90
  def to_degrees
    degrees = super
    if degrees > 270
      -(360 - degrees)
    elsif degrees > 180 || degrees > 90 || degrees < -90
      180 - degrees
    else
      degrees
    end
  end

  # @return [Float] angle as degrees in range -PI and PI
  def to_radians
    if @angle > 3 * Math::PI / 2
      @angle - Math::PI * 2
    elsif @angle > Math::PI || @angle > Math::PI / 2
      Math::PI - @angle
    elsif @angle < -Math::PI / 2
      -Math::PI - @angle
    else
      @angle
    end
  end

  # @return [String] angle as string in degrees minutes seconds direction.
  # A South angle is negative, North is Positive.
  # @param [String] fmt Optional format string passed to Angle#to_s
  def to_s(fmt = "%2d %2m'%2.4s\"%N")
    super(fmt)
  end

  alias to_r to_radians
  alias to_rad to_radians
  # alias to_d to_degrees
  alias to_deg to_degrees
end
