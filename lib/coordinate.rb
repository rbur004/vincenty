#Holds both latitude and longitude, and the altitude at that point

require 'angle.rb'

class Coordinate
  attr_accessor :latitude, :longitude, :altitude
  #latitude and longitude can be Strings or Numeric, or anything else with to_radians and to_f
  #latitude and longitude are in degrees unless radians == true
  def initialize(latitude=0, longitude=0, altitude=0, radians = false)
    @latitude = Latitude.new(latitude,radians)
    @longitude = Longitude.new(longitude,radians)
    @altitude = altitude.to_f
  end
  
  #Returns: Latitude longitude and altitude as a single string.
  def to_s
    "#{@latitude.to_s }  #{@longitude.to_s} #{@altitude}m"
  end
  
  def to_ary
    [ @latitude, @longitude, @altitude ]
  end
  
  alias to_a to_ary
  
  def to_hash
    { :latitude => @latitude, :longitude => @longitude, :altitude => @altitude }
  end
end