
require 'angle.rb'

#Subclass of Angle to add in special treatment of to_d, to_r and to_s
#Longitude degrees are between -2PI and 2PI, West to East (+/- 180 degrees)

class Longitude < Angle
  
  #Returns angle as degrees in range -180 and 180
  def to_degrees
    degrees = super
    case
      when degrees > 180 ; degrees - 360
      else degrees
    end
  end
  
  #Returns: angle as degrees in range -2PI and 2PI
  def to_radians
    case
      when @angle > Math::PI ; @angle - 2 * Math::PI
      else @angle
    end
  end
  
  #Returns: angle as string in degrees minutes seconds direction.
  #A West angle is negative, East is Positive.
  def to_s(fmt="%3d %2m'%2.4s\"%E")
    super(fmt)
  end
  
  alias to_r to_radians
  alias to_d to_degrees
  
end