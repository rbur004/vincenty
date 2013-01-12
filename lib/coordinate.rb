
require 'angle.rb'

#Holds the latitude, longitude, and the altitude for the coordinate
class Coordinate
  attr_accessor :latitude, :longitude, :altitude
  
  #latitude and longitude can be Strings or Numeric, or anything else with to_radians and to_f
  #latitude and longitude are in degrees unless radians == true (or set to :radians)
  def initialize(latitude=0, longitude=0, altitude=0, radians = false)
    @latitude = Latitude.new(latitude,radians)
    @longitude = Longitude.new(longitude,radians)
    @altitude = altitude.to_f
  end
  
  #Returns: Latitude longitude and altitude as a single string.
  #Should add an optional format string to this.
  def to_s
    "#{@latitude.to_s }  #{@longitude.to_s} #{@altitude}m"
  end
  
  #Return coordinate as a 3 member array, with
  #members, latitude, longitude and altitude
  def to_ary
    [ @latitude, @longitude, @altitude ]
  end
  
  alias to_a to_ary
  
  #return coordinate a 3 member hash with
  #keys :latitude, :longitude, and :altitude
  def to_hash
    { :latitude => @latitude, :longitude => @longitude, :altitude => @altitude }
  end
end