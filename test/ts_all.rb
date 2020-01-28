require 'vincenty'
include Vincenty

require 'ts_angle.rb'
require 'ts_vincenty.rb'
require 'ts_latitude.rb'
require 'ts_longitude.rb'
require 'ts_coordinate.rb'
require 'ts_track_and_distance.rb'

puts "Testing from installed Gem"
puts Vincenty::VERSION
