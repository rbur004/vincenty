#Subclass of Angle to add in special treatment of to_d, to_r , to_s

require 'angle.rb'

class Latitude < Angle
  #Latitude degrees are between -90 and 90, South to North
  #Returns angle as degrees in range -90 and 90
  def to_degrees
    #longitude's are -180 to 180 for west to east
    degrees = super
    case
    when degrees > 270 : -(360 - degrees)
    when degrees > 180 : 180 - degrees
    when degrees > 90 : 180 - degrees
    when degrees < -90 : 180 - degrees
    else degrees
    end
  end
  
  #Latitude degrees are between -PI and PI, South to North
  #Returns: angle as degrees in range -PI and PI
  def to_radians
    #longitude's are -180 to 180 for west to east
    case
    when @value > 3*Math::PI/2 :  @value - Math::PI * 2
    when @value > Math::PI : Math::PI - @value
    when @value > Math::PI/2 : Math::PI - @value
    when @value < -Math::PI/2 : -Math::PI - @value
    else @value
    end
  end

  #Returns: angle as string in degrees minutes seconds direction.
  #A South angle is negative, North is Positive.
  def to_s(fmt='%2d°%2m′%2.4s″%N')
      super(fmt)
  end
  
  alias to_r to_radians
  alias to_d to_degrees

end