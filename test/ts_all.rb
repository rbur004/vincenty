#!/usr/bin/env ruby
require_relative 'ts_angle.rb'
require_relative 'ts_vincenty.rb'
require_relative 'ts_latitude.rb'
require_relative 'ts_longitude.rb'
require_relative 'ts_coordinate.rb'
require_relative 'ts_track_and_distance.rb'

puts 'Testing from source'
puts Vincenty.new.version
