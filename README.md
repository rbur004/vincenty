# Vincenty
[![Gem Version](https://badge.fury.io/rb/vincenty.svg)](https://rubygems.org/gems/vincenty)
[![Build Status](https://travis-ci.org/rbur004/vincenty.svg)](https://travis-ci.org/rbur004/vincenty)

* Source https://github.com/rbur004/vincenty
* https://rubygems.org/gems/vincenty

## DESCRIPTION:

* Vincenty wrote an algorithm for calculating the bearing and distance between two coordinates on the earth
  and an algorithm for finding a second coordinate, given a starting coordinate, bearing and destination.
  The algorithms model the earth as an ellipsoid, using the WGS-84 model. This is the common GPS model for
  mapping to latitudes and longitudes.

  This is a Ruby implementation of Vincenty's algorithms, and the Vincenty class includes two methods for
  modeling the earth as a sphere. These were added as a reference for testing the Vincenty algorithm, but
  could be used on their own.

  The package also makes use of several other classes that may be useful in their own Right. These include
  class Angle, class Latitude (subclass of Angle), class Longitude (subclass of Angle),
  class TrackAndBearing and class coordinate (which class Vincenty is a subclass)

  Angle requires extensions to Numeric and String to provide to_radians (to_r) and to_degrees (to_d). String also includes a to_decimal_degrees(), which converts most string forms of Latitude and Longitude to decimal form. These extensions are included in the package in core_extensions.rb.

*  The Vincenty code is based on the wikipedia presentation of the Vincenty algorithm http://en.wikipedia.org/wiki/Vincenty%27s_formulae .
*  The algorithm was modified to include changes I found at http://www.movable-type.co.uk/scripts/latlong-vincenty-direct.html.
*  I also altered the formulae to correctly return the bearing for angles greater than 180.

* Vincenty's original publication

** T Vincenty, "Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations", Survey Review, vol XXII no 176, 1975 http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf

## FEATURES/PROBLEMS:

* None that I yet know of :)

## SYNOPSIS:

```ruby
  flindersPeak = Vincenty.new("-37°57′3.72030''", "144°25′29.52440''" )
  buninyong = Vincenty.new("-37° 39' 10.15610''", "143° 55' 35.38390''")
  track_and_bearing = flindersPeak.distanceAndAngle( buninyong )
  puts track_and_bearing

  #or the reverse
  destination = flindersPeak.destination(TrackAndDistance.new("306° 52' 5.37\"", 54972.271))
  puts destination

  #Angles is the parent class of Latitude and Longitude
  Angle.new("-37°01′.125").strf( "The angle is %d°%2m′%2.5s′%N" ) -> "The angle is 37°01′07.50000′S"
```

## REQUIREMENTS:

* `require 'rubygems'`

## INSTALL:

* `sudo gem install vincenty`

## CONTRIBUTING:

* Run tests with `ruby -Ilib:test test/ts_all.rb`
* Generate documentation with `gendoc.sh`
* Create packaged gem with `genpkg.sh`
* Push packaged gem with `exportgem.sh`

## LICENSE:

Code unique to this implementation of Vincentys algrithm is distributed under the Ruby License.

Copyright (c) 2009

1. You may make and give away verbatim copies of the source form of the
   software without restriction, provided that you duplicate all of the
   original copyright notices and associated disclaimers.

2. You may modify your copy of the software in any way, provided that
   you do at least ONE of the following:
    *  place your modifications in the Public Domain or otherwise make them Freely Available, such as by posting said modifications to Usenet or an equivalent medium, or by allowing the author to include your modifications in the software.
    *  use the modified software only within your corporation or organization.
    *  rename any non-standard executables so the names do not conflict with standard executables, which must also be provided.
    *  make other distribution arrangements with the author.

3. You may distribute the software in object code or executable form, provided that you do at least ONE of the following:
    * distribute the executables and library files of the software,
  together with instructions (in the manual page or equivalent)
  on where to get the original distribution.
    * accompany the distribution with the machine-readable source of
  the software.
    * give non-standard executables non-standard names, with
        instructions on where to get the original software distribution.
    * make other distribution arrangements with the author.

4. You may modify and include the part of the software into any other
   software (possibly commercial).  But some files or libraries used by
   code in this distribution  may not written by the author, so that they
   are not under these terms.

5. The scripts and library files supplied as input to or produced as
   output from the software do not automatically fall under the
   copyright of the software, but belong to whomever generated them,
   and may be sold commercially, and may be aggregated with this
   software.

6. THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE.
