require_relative 'core_extensions'
require_relative 'angle'
require_relative 'latitude'
require_relative 'longitude'
require_relative 'line'
require_relative 'segment'
require_relative 'track_and_distance'
require_relative 'coordinate'

module Vincenty
  VERSION = '1.1.0'

  WGS84_ER = 6378137              #Equatorial Radius of earth
  WGS84_IF = 298.257223563        #Inverse Flattening
  GRS80_ER = 6378137              #Equatorial Radius of earth
  GRS80_IF = 298.25722210882711   #Inverse Flattening
end
