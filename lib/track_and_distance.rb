
require 'angle.rb'

#Holds a bearing and distance
class TrackAndDistance
    attr_accessor :bearing, :distance
    
    #Bearing is in degrees unless radians == true (or set to :radians).
    #Bearing can be a String or Numeric or any object with to_radians and to_f
    def initialize(bearing, distance, radians=false)
      @bearing = Angle.new(bearing, radians)
      @distance = distance
    end
    
    #format string fmt is currently just for the bearing angle.
    #Need to change this to include the distance is single format string.
    #Returns: Bearing angle and distance in a string.
    def to_s(fmt = nil)
      if(fmt)
        #needs work to include distance as well as angle fmt.
        "#{@bearing.strf(fmt)} #{distance.round(4)}m"
      else
        "#{@bearing.strf} #{distance.round(4)}m"
      end
    end

    #Returns an array with members bearing and distance.
    def to_ary
      [ @bearing, @distance ]
    end
    
    #Returns a hash with keys :bearing and :distance
    def to_hash
      { :bearing => @bearing, :distance => @distance }
    end
end