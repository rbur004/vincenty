#Holds a bearing and distance

require 'angle.rb'

class TrackAndDistance
    attr_accessor :bearing, :distance
    #Bearing is in degrees unless radians == true.
    #Bearing can be a String or Numeric or any object with to_radians and to_f
    def initialize(bearing, distance, radians=false)
      @bearing = Angle.new(bearing, radians)
      @distance = distance
    end
    
    #Returns: Bearing angle and distance in a string.
    def to_s
      "#{@bearing.to_d.round(4)} #{distance.round(4)}m"
    end

    def to_ary
      [ @bearing, @distance ]
    end
    
    def to_hash
      { :bearing => @bearing, :distance => @distance }
    end
end