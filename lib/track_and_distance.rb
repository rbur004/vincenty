
require_relative 'angle'

module Vincenty

  #Holds a bearing and distance
  class TrackAndDistance
    # @return [Angle]
    attr_accessor :bearing
    # @return [Float]
    attr_accessor :distance

    # @param [String, Numeric, #to_radian, #to_f] Bearing can be a String or Numeric or any object with to_radians and to_f
    # @param [Numeric] distance
    # @param [true,false, :radians] radians Bearing is in degrees unless radians == true (or set to :radians).
    def initialize(bearing, distance, radians=false)
      @bearing = Angle.new(bearing, radians)
      @distance = distance
    end

    # return [Float] distance in meters
    def northings
      @distance * Math.cos(@bearing.to_radians)
    end

    # return [Float] distance in meters
    def eastings
      @distance * Math.sin(@bearing.to_radians)
    end

    alias x eastings
    alias y northings

    #Class level function equivalent to TrackAndDistance.new that takes X and Y in meters
    # @return [TrackAndDistance
    # @param [#to_f] eastings Value in meters representing eastings
    # @param [#to_f] northings Value in meters representing northings
    def self.from_xy(eastings, northings)
      self.new(Angle.radians(Math.atan2(eastings, northings)), Math.hypot(eastings, northings), true)
    end

    #format string fmt is currently just for the bearing angle.
    #Need to change this to include the distance is single format string.
    # @return [String] Bearing angle and distance in meters.
    # @param [String] fmt Optional format string passed to Coordinate#strf
    def to_s(fmt = nil)
      if(fmt)
        #needs work to include distance as well as angle fmt.
        "#{@bearing.strf(fmt)} #{distance.round(4)}m"
      else
        "#{@bearing.strf} #{distance.round(4)}m"
      end
    end

    # @return [Array] with members bearing and distance.
    def to_ary
      [ @bearing, @distance ]
    end

    # @return [Hash] with keys :bearing and :distance
    def to_hash
      { :bearing => @bearing, :distance => @distance }
    end
  end
end
