
require_relative 'angle'

module Vincenty

  #Subclass of Angle to add in special treatment of to_d, to_r and to_s
  #Longitude degrees are between -2PI and 2PI, West to East (+/- 180 degrees)

  class Longitude < Angle

    # @return [Float] angle as degrees in range -2PI and 2PI
    def constrained_angle(angle)
      Angle::wrap(angle, 2 * Math::PI, -Math::PI).to_radians
    end

    # @return [String] angle as string in degrees minutes seconds direction.
    #A West angle is negative, East is Positive.
    # @param [String] fmt Optional format string passed to Angle#to_s
    def to_s(fmt="%3d %2m'%2.4s\"%E")
      super(fmt)
    end

  end
end
