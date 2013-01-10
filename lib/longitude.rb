#Subclass of Angle to add in special treatment of to_d, to_r and to_s

require 'angle.rb'

class Longitude < Angle
  #Longitude degrees are between -180 and 180 West to East
  #Returns angle as degrees in range -180 and 180
  def to_degrees
    degrees = super
    case
      when degrees > 180 ; degrees - 360
      else degrees
    end
  end
  
  #Longitude degrees are between -2PI and 2PI, West to East
  #Returns: angle as degrees in range -2PI and 2PI
  def to_radians
    case
      when @value > Math::PI ; @value - 2 * Math::PI
      else @value
    end
  end
  
  #Returns: angle as string in degrees minutes seconds direction.
  #A West angle is negative, East is Positive.
  def to_s(fmt='%3d^0%2m'%2.4s''%E')
    super(fmt)
  end
  
  alias to_r to_radians
  alias to_d to_degrees
  
end