require_relative 'core_extensions.rb'
require_relative 'angle.rb'
require_relative 'latitude.rb'
require_relative 'longitude.rb'
require_relative 'track_and_distance.rb'
require_relative 'coordinate.rb'

# Vincenty's algorithms for finding the bearing and distance between two coordinates and
# for finding the latitude and longitude, given a start coordinate, distance and bearing.
#
# Coded from formulae from Wikipedia http://en.wikipedia.org/wiki/Vincenty%27s_formulae
# Modified to incorporate corrections to formulae as found in script on http://www.movable-type.co.uk/scripts/LatLongVincenty.html
# Added my Modification of the distanceAndAngle formulae to correct the compass bearing.
class Vincenty < Coordinate
  VERSION = '1.0.12'

  # @return [String] constant VERSION
  def version
    VERSION
  end

  WGS84_ER = 6378137              # Equatorial Radius of earth
  WGS84_IF = 298.257223563        # Inverse Flattening
  GRS80_ER = 6378137              # Equatorial Radius of earth
  GRS80_IF = 298.25722210882711   # Inverse Flattening

  # Great Circle formulae  http://en.wikipedia.org/wiki/Great-circle_distance
  # Reference calculation for testing, assumes the earth is a sphere, which it isn't.
  # This gives us an approximation to verify Vincenty algorithm.
  # @param [Coordinate] p2 is target coordinate that we want the bearing to.
  # @return [TrackAndDistance]  with the compass bearing and distance in meters to P2
  def sphericalDistanceAndAngle( p2, equatorial_radius = WGS84_ER, inverse_flattening = WGS84_IF )
    # No calculations necessary, if these are the same point.
    return TrackAndDistance.new(0, 0, true) if @latitude == p2.latitude && @longitude == p2.longitude

    a = equatorial_radius # equatorial radius in meters     (+/-2 m)
    b = a - a / inverse_flattening # WGS84 = 6356752.314245179 polar radius in meters
    r = (a + b) / 2 # average diametre as a rough estimate for our tests.

    sin_lat1 = Math.sin(@latitude.to_rad)
    sin_lat2 = Math.sin(p2.latitude.to_rad)
    cos_lat1 = Math.cos(@latitude.to_rad)
    atan1_2 = Math.atan(1) * 2
    t1 = cos_lat1 * Math.cos(p2.latitude.to_rad) * Math.cos(@longitude.to_rad - p2.longitude.to_rad) + sin_lat1 * sin_lat2
    angular_distance = Math.atan(-t1 / Math.sqrt(-t1 * t1 + 1)) + atan1_2 # central angle in radians so we can calculate the arc length.
    t2 = (sin_lat2 - sin_lat1 * Math.cos(angular_distance)) / (cos_lat1 * Math.sin(angular_distance))

    bearing = if @longitude == p2.longitude
                @latitude > p2.latitude ? Math::PI : 0
              elsif Math.sin(p2.longitude.to_rad - @longitude.to_rad) < 0
                2 * Math::PI - (Math.atan(-t2 / Math.sqrt(-t2 * t2 + 1)) + atan1_2) # Compass Bearing in radians (clockwise)
              else
                Math.atan(-t2 / Math.sqrt(-t2 * t2 + 1)) + atan1_2 # Compass Bearing in radians (clockwise)
              end

    # Note that the bearing is a compass angle. That is angles are positive clockwise.
    return TrackAndDistance.new(bearing, angular_distance * r, true)
  end

  # Vincenty's algorithm for finding bearing and distance between to coordinates.
  # Assumes earth is a WGS-84 Ellipsod.
  # @param [Coordinate] p2 is target coordinate that we want the bearing to.
  # @return [TrackAndDistance] with the compass bearing and distance in meters to P2
  def distanceAndAngle( p2 )
    if self.latitude == p2.latitude && self.longitude == p2.longitude
      return TrackAndDistance.new(0, 0, true) # No calculations necessary. Solv NAN issue
    end

    # a, b = major & minor semiaxes of the ellipsoid
    a = 6378137 # equatorial radius in meters     (+/-2 m)
    b = 6356752.31424518 # polar radius in meters
    f = (a - b) / a #  flattening

    lat1 = @latitude.to_rad
    lon1 = @longitude.to_rad
    lat2 = p2.latitude.to_rad
    lon2 = p2.longitude.to_rad
    lat1 = lat1.sign * (Math::PI / 2 - 1e-10) if (Math::PI / 2 - lat1.abs).abs < 1.0e-10
    lat2 = lat2.sign * (Math::PI / 2 - 1e-10) if (Math::PI / 2 - lat2.abs).abs < 1.0e-10

    #  lat1, lat2 = geodetic latitude

    l = (lon2 - lon1).abs # difference in longitude
    l = 2 * Math::PI - l if l > Math::PI
    u1 = Math.atan( ( 1 - f) * Math.tan( lat1 ) ) # U is 'reduced latitude'
    u2 = Math.atan( ( 1 - f) * Math.tan( lat2 ) )
    sin_u1 = Math.sin(u1)
    cos_u1 = Math.cos(u1)
    sin_u2 = Math.sin(u2)
    cos_u2 = Math.cos(u2)

    lambda_v = l
    lambda_dash = Math::PI * 2
    while (lambda_v - lambda_dash).abs > 1.0e-12  # i.e. 0.06 mm error
      sin_lambda_v = Math.sin(lambda_v)
      cos_lambda_v = Math.cos(lambda_v)
      sin_sigma = Math.sqrt( ( cos_u2 * sin_lambda_v )**2 + ( cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda_v )**2 )
      cos_sigma = sin_u1 * sin_u2 + cos_u1 * cos_u2 * cos_lambda_v
      sigma = Math.atan2(sin_sigma, cos_sigma)
      sin_alpha = cos_u1 * cos_u2 * sin_lambda_v / sin_sigma
      cos_2_alpha = 1 - sin_alpha * sin_alpha # trig identity
      cos_2_sigma_m = cos_sigma - 2 * sin_u1 * sin_u2 / cos_2_alpha
      c = f / 16 * cos_2_alpha * (4 + f * (4 - 3 * cos_2_alpha))
      lambda_dash = lambda_v
      lambda_v = l + (1 - c) * f * sin_alpha * (sigma + c * sin_sigma * (cos_2_sigma_m + c * cos_sigma * (-1 + 2 * cos_2_sigma_m * cos_2_sigma_m) ) )  # use cos_2_sigma_m=0 when over equatorial lines
      if lambda_v > Math::PI
        lambda_v = Math::PI
        break
      end
    end

    u_2 = cos_2_alpha * (a * a - b * b) / (b * b)
    a1 = 1 + u_2 / 16384 * (4096 + u_2 * (-768 + u_2 * (320 - 175 * u_2)))
    b1 = u_2 / 1024 * (256 + u_2 * (-128 + u_2 * (74 - 47 * u_2)))
    delta_sigma = b1 * sin_sigma * (cos_2_sigma_m + b1 / 4 * (cos_sigma * (-1 + 2 * cos_2_sigma_m * cos_2_sigma_m) - b1 / 6 * cos_2_sigma_m * (-3 + 4 * sin_sigma * sin_sigma) * (-3 + 4 * cos_2_sigma_m * cos_2_sigma_m)))
    s = b * a1 * (sigma - delta_sigma)
    sin_lambda_v = Math.sin(lambda_v)
    cos_lambda_v = Math.cos(lambda_v)

    # This test isn't in original formulae, and fixes the problem of all angles returned being between 0 - PI (0-180)
    # Also converts the result to compass bearing, rather than the mathmatical anticlockwise angles.
    alpha_1 = if Math.sin(p2.longitude.to_rad - @longitude.to_rad) < 0
                Math::PI * 2 - Math.atan2( cos_u2 * sin_lambda_v, cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda_v)
              # alpha_2 = Math::PI*2-Math.atan2(cos_u1 * sin_lambda_v, -sin_u1 * cos_u2 + cos_u1 * sin_u2 * cos_lambda_v)
              else
                Math.atan2( cos_u2 * sin_lambda_v, cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda_v)
                # alpha_2 = Math.atan2(cos_u1 * sin_lambda_v, -sin_u1 * cos_u2 + cos_u1 * sin_u2 * cos_lambda_v)
              end

    # Note that the bearing is a compass (i.e. clockwise) angle.
    return TrackAndDistance.new(alpha_1, s, true) # What to do with alpha_2?
  end

  # spherical earth estimate of calculation for finding target coordinate from start coordinate, bearing and distance
  # Used to run checks on the Vincenty algorithm
  # @param [TrackAndDistance] track_and_distance specifying  bearing and distance.
  # @return [Vincenty]  with the destination coordinates.
  def sphereDestination( track_and_distance )
    a = 6378137 # equatorial radius in meters     (+/-2 m)
    b = 6356752.31424518 # polar radius in meters
    r = (a + b) / 2 # average diametre as a rough estimate for our tests.

    d = track_and_distance.distance.abs
    sin_dor = Math.sin(d / r)
    cos_dor = Math.cos(d / r)
    sin_lat1 = Math.sin(@latitude.to_rad)
    cos_lat1 = Math.cos(@latitude.to_rad)
    lat2 = Math.asin( sin_lat1 * cos_dor + cos_lat1 * sin_dor * Math.cos(track_and_distance.bearing.to_rad) )
    lon2 = @longitude.to_rad + Math.atan2(Math.sin(track_and_distance.bearing.to_rad) * sin_dor * cos_lat1, cos_dor - sin_lat1 * Math.sin(lat2))

    Vincenty.new(lat2, lon2, 0, true)
  end

  #
  # Calculate destination point given start point lat/long, bearing and distance.
  # Assumes earth is a WGS-84 Ellipsod.
  # @param [TrackAndDistance]  specifying bearing and distance.
  # @return [Vincenty] with the destination coordinates.
  def destination( track_and_distance )
    # a, b = major & minor semiaxes of the ellipsoid
    a = 6378137 # equatorial radius in meters     (+/-2 m)
    b = 6356752.31424518 # polar radius in meters
    f = (a - b) / a #  flattening

    s = track_and_distance.distance.abs
    alpha1 = track_and_distance.bearing.to_rad
    sin_alpha1 = Math.sin(alpha1)
    cos_alpha1 = Math.cos(alpha1)

    tanU1 = (1 - f) * Math.tan(@latitude.to_rad)
    cosU1 = 1 / Math.sqrt((1 + tanU1 * tanU1))
    sinU1 = tanU1 * cosU1
    sigma1 = Math.atan2(tanU1, cos_alpha1)
    sin_alpha = cosU1 * sin_alpha1
    cos_2_alpha = 1 - sin_alpha * sin_alpha # Trig identity
    u_2 = cos_2_alpha * (a * a - b * b) / (b * b)
    a1 = 1 + u_2 / 16384 * (4096 + u_2 * (-768 + u_2 * (320 - 175 * u_2)))
    b1 = u_2 / 1024 * (256 + u_2 * (-128 + u_2 * (74 - 47 * u_2)))

    sigma = s / (b * a1)
    sigma_dash = 2 * Math::PI
    while (sigma - sigma_dash).abs > 1.0e-12 # i.e 0.06mm
      cos_2_sigma_m = Math.cos(2 * sigma1 + sigma)
      sin_sigma = Math.sin(sigma)
      cos_sigma = Math.cos(sigma)
      delta_sigma = b1 * sin_sigma * (cos_2_sigma_m + b1 / 4 * (cos_sigma * (-1 + 2 * cos_2_sigma_m * cos_2_sigma_m) - b1 / 6 * cos_2_sigma_m * (-3 + 4 * sin_sigma * sin_sigma) * (-3 + 4 * cos_2_sigma_m * cos_2_sigma_m)))
      sigma_dash = sigma
      sigma = s / (b * a1) + delta_sigma
    end

    tmp = sinU1 * sin_sigma - cosU1 * cos_sigma * cos_alpha1
    lat2 = Math.atan2(sinU1 * cos_sigma + cosU1 * sin_sigma * cos_alpha1, (1 - f) * Math.sqrt(sin_alpha * sin_alpha + tmp * tmp))
    lambda_v = Math.atan2(sin_sigma * sin_alpha1, cosU1 * cos_sigma - sinU1 * sin_sigma * cos_alpha1)
    c = f / 16 * cos_2_alpha * (4 + f * (4 - 3 * cos_2_alpha))
    l = lambda_v - (1 - c) * f * sin_alpha * (sigma + c * sin_sigma * (cos_2_sigma_m + c * cos_sigma * (-1 + 2 * cos_2_sigma_m * cos_2_sigma_m))) # difference in longitude

    # sigma2 = Math.atan2(sin_alpha, -tmp)  # reverse azimuth

    return Vincenty.new(lat2, @longitude + l, 0, true)
  end
end
