#!/usr/bin/env ruby
require 'test/unit'
require_relative '../lib/vincenty.rb'

class TestAngle< Test::Unit::TestCase
  #test Angle creation
  def test_angle
    assert_equal(Angle.new(), 0)
    assert_equal(Angle.new("S37 01'7.5\"").to_deg,  -37.01875) #Leading NSEW
    assert_equal(Angle.new("37 01'7.5\"S").to_deg ,  -37.01875) #Trailing NSEW
    assert_equal(Angle.new("-37 01'7.5\"").to_deg,  -37.01875) #Use of - rather than S or W
    assert_equal(Angle.new("-37  1.125'").to_deg, -37.01875) #Decimal minutes, rather than minutes and seconds.
    assert_equal(Angle.new("-37 01'.125").to_deg, -37.01875) #Nb. the minute marker ' between the minutes and fraction
    assert_equal(Angle.new("S37 01'.125").to_deg, -37.01875) #Nb. the minute marker ' between the minutes and fraction
    assert_equal(Angle.new("37 01'.125S").to_deg, -37.01875) #Nb. the minute marker ' between the minutes and fraction
    assert_equal(Angle.new("-37.01875 ").to_deg, -37.01875) #decimal degrees, rather than deg, min, sec.
    assert_equal(Angle.new([-37, 1, 7.5]).to_deg,  -37.01875) #an array of deg,min,sec
    assert_equal(Angle.new(-37.01875).to_deg, -37.01875)
    assert_equal(Angle.degrees(-37.01875).to_deg, -37.01875)
    assert_equal(Angle.degrees(-37.01875).to_rad.round(15), -0.646099072472651)
    assert_equal(Angle.new(-0.646099072472651, true).to_deg.round(5), -37.01875)
    assert_equal(Angle.new(-0.646099072472651, true).to_rad, -0.646099072472651)
    assert_equal(Angle.radians(-0.646099072472651).to_deg.round(5), -37.01875)
    assert_equal(Angle.radians(-0.646099072472651).value, Angle.radians(-0.646099072472651).angle)
    assert_equal(Angle.decimal_deg(1,2,3,'S'), -(1.0 + 2/60.0 + 3/3600.0))
    assert_equal(Angle.decimal_deg(1,2,3,'E'), (1.0 + 2/60.0 + 3/3600.0))
    assert_equal(Angle.decimal_deg(1,2,4,'N'), (1.0 + 2/60.0 + 4/3600.0))
    assert_equal(Angle.decimal_deg(1,5,4,'W'), -(1.0 + 5/60.0 + 4/3600.0))
    assert_equal(Angle.decimal_deg_from_ary([1,5,4,'W']), -(1.0 + 5/60.0 + 4/3600.0))
    assert_equal(Angle.decimal_deg_from_ary(Angle.dms( -(1.0 + 5/60.0 + 1.0/3600.0) )),-(1.0 + 5/60.0 + 1.0/3600.0)) #double call, rounding error always produced a failure.
  end

  def test_strf
    a = Angle.new("S37 01'7.5\"")
    assert_equal("-37 01'07.5000\"", a.strf) #default format of strf
    assert_equal("37 01'07.50000\"S", a.strf( "%d %2m'%2.5s\"%N" ))
    assert_equal("37 01'07.50000\"W", a.strf("%d %2m'%2.5s\"%E" ))
    assert_equal("-37 01'07.5000\"", a.strf("%d %2m'%2.4s\"" ))
    assert_equal("-37 01.1250'\n", a.strf("%d %2.4M'\n" ))
    assert_equal("*** -37 01'.1250", a.strf( "*** %d %2m'%4W" )) #puting the minute ' before decimal point.
    assert_equal("-37.01875 ", a.strf("%0.5D " ))
    assert_equal("-0.64610 radians\n", a.strf("%0.5r radians\n" ))

    assert_equal("-037 01'7.5000\"", Angle.new("-37 01'7.5\"").to_s('%3d %2m\'%1.4s"')) #testing leading 0 with -deg, no leading 0 %s
    assert_equal("00 01'07.5000\"S", Angle.new("0 01'7.5\"S").to_s('%2d %2m\'%2.4s"%N')) #testing 0 degrees and leading 0 %s
    assert_equal("00 -01'07.5000\"", Angle.new("0 01'7.5\"S").to_s('%2d %2m\'%2.4s"')) #testing 0 degrees and -min
    assert_equal("00 -01'07.5000\"", Angle.new("0 01'7.5\"S").to_s('%2d %2m\'%2.4s"') ) #test of 0 degrees, -min, no NSEW
    assert_equal("000 00'07.5000\"W", Angle.new("0 0'7.5\"W").to_s('%3d %2m\'%2.4s"%E') ) #testing E W 0 deg and 0 min and -sec
    assert_equal("00 00'-07.5000\"", Angle.new("0 0'7.5\"S").to_s('%2d %2m\'%2.4s"') ) #testing 0 deg and 0 min and -sec no NSEW
  end

  def test_operators
    #Comparable.
    assert_equal(Angle.radians(-0.646099072472651), Angle.radians(-0.646099072472651)) #<=>
    #unary-op Angle
    assert_equal(+Angle.radians(-0.646099072472651), Angle.radians(-0.646099072472651)) #unary +
    assert_equal(-Angle.radians(-0.646099072472651), Angle.radians(0.646099072472651)) #unary -
    #Angle op Numeric
    assert_equal(5, Angle.radians(2) +  3) # +
    assert_equal(-1, Angle.radians(2) -  3) # -
    assert_equal(6, Angle.radians(2) *  3) # *
    assert_equal(2, Angle.radians(4) /2) # /
    assert_equal(1, Angle.radians(4) % 3) # %
    assert_equal(64, Angle.radians(4) ** 3) # **
    #Numeric op Angle
    assert_equal(5.1, 3.1 + Angle.radians(2) ) # +
    assert_equal(2.646099072472651, 2 - Angle.radians(-0.646099072472651) ) # -
    assert_equal(6, 3 * Angle.radians(2) ) # *
    assert_equal(2, 4 / Angle.radians(2) ) # /
    #Angle op Angle
    assert_equal(Angle.radians(3.2+2.1), Angle.radians(3.2) + Angle.radians(2.1) ) # +
    #Sign method.
    assert_equal(1, Angle.radians(3).sign)
    assert_equal(-1, Angle.radians(-3).sign)
    #abs
    assert_equal(3, Angle.radians(-3).abs)
    #reverse
    assert_equal(Angle.degrees(90), Angle.degrees(270).reverse)
    #bearing
    assert_equal(Angle.degrees(340), Angle.degrees(20).to_bearing)
  end
end
