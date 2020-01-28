
require_relative 'angle'

module Vincenty

  #Subclass of Angle to add in special treatment of to_d, to_r , to_s
  #Latitude degrees are between -PI and PI, South to North (+/- 90 degrees)

  class Latitude < Angle

    # @return [Float] angle as degrees in range -PI and PI
    def constrained_angle(angle)
      full = 2 * Math::PI
      quarter = Math::PI / 2
      ret = Angle::wrap(angle, full, -quarter).to_radians
      ret = quarter - (ret - quarter) if ret > quarter
      ret
    end

    # @return [String] angle as string in degrees minutes seconds direction.
    #A South angle is negative, North is Positive.
    # @param [String] fmt Optional format string passed to Angle#to_s
    def to_s(fmt="%2d %2m'%2.4s\"%N")
      super(fmt)
    end

  end
end
