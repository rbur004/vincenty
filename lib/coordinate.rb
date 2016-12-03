
require_relative 'angle.rb'

#Holds the latitude, longitude, and the altitude for the coordinate
class Coordinate
  # @return [Latitude]
  attr_accessor :latitude
  # @return [Longitude]
  attr_accessor :longitude
  # @return [Numeric]
  attr_accessor :altitude

  #latitude and longitude can be Strings or Numeric, or anything else with to_radians and to_f
  #latitude and longitude are in degrees unless radians == true (or set to :radians)
  def initialize(latitude=0, longitude=0, altitude=0, radians = false)
    @latitude = Latitude.new(latitude,radians)
    @longitude = Longitude.new(longitude,radians)
    @altitude = altitude.to_f
  end

  # @return [String] Latitude longitude and altitude as a single space separated string.
  def to_s
    "#{@latitude.to_s }  #{@longitude.to_s} #{@altitude}m"
  end

  # @return [Latitude, Longitude, Float] with members, latitude, longitude and altitude
  def to_ary
    [ @latitude, @longitude, @altitude ]
  end

  alias to_a to_ary

  # @return [Hash] with keys :latitude, :longitude, and :altitude
  def to_hash
    { :latitude => @latitude, :longitude => @longitude, :altitude => @altitude }
  end
end
