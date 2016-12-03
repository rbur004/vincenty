require_relative 'core_extensions.rb'

#Class Angle is a utility class that allows
# * Angle arithmetic ( +,-,*,/,**,% and unary +,-)
# * Angle comparison ( <=>, hence, <, >, >=, <=, == )
# * Conversion to and from degrees and radians
# * Conversion to string as radians or DMS format

class Angle
  include Comparable

  # @return [Float] stored in radians
  attr_accessor :angle
  alias :value :angle    #Older version of angle used volue rather than angle
  alias :value= :angle=  #Older version of angle used volue rather than angle

  # @param [#to_f,#to_radians] angle may be anything that has a to_f and to_radians.
  # @param [true,false, :radians] radians Angle is in degrees unless radians == true (or set to :radians).
  def initialize(angle=0, radians=false)
    #assumes that we are getting an angle in degrees.
    if radians == true || radians == :radians
      @angle = angle.to_f #works for String, Fixed, other Angles and for Float.
    else
      if angle.class == Array
        @angle = self.class.decimal_deg(*angle).to_radians #Wild assumption that the array is deg,min,sec.
      else
        @angle = angle.to_radians #we have a String and Numeric class version of this. Another Angle will work too.
      end
    end
  end


  #Class level function that converts 4 arguments into decimal degrees.
  # @return [Float] signed decimal degrees.
  # @param [Numeric] degrees
  # @param [Numeric] minutes
  # @param [Numeric] seconds
  # @param ['N', 'S', 'E', 'W'] direction Optional, as the direction might be specified by a negative value for degrees
  def self.decimal_deg(degrees=0, minutes=0, seconds=0, direction='N')
    s = { 'N'=>1, 'S'=>-1, 'E'=>1, 'W'=>-1, 'n'=>1, 's'=>-1, 'e'=>1, 'w'=>-1 }
    sign = s[direction]
    sign = sign == nil ? 1 : sign #Assume 'N' or 'E' if the direction is not set.
    #Shouldn't have a negative value for degrees if the direction is specified.
    #I am defaulting to the degrees sign if it is set, otherwise the direction given
    sign = degrees.sign == -1 || (degrees == 0 && (minutes < 0 || (minutes == 0 && seconds < 0))) ? -1 : sign
    sign * (degrees.abs + minutes/60.0 + seconds/3600.0)
  end

  #Class level function that takes an array of [degress,minutes, seconds, direction] or [degrees,minutes,seconds]
  # @return [Float] signed decimal degrees.
  # @param [Array] a Array is expanded and passed as degrees,minutes,seconds,direction to Angle#decimal_deg
  def self.decimal_deg_from_ary(a)
    self.decimal_deg(*a)
  end

  #Class level utility function to return the angle as deg,min,sec
  #Assumes decimal degress unless radians == true .
  # @return [Array] of signed deg, min, sec.
  #Nb. * That min will be negative if the angle is negative and deg == 0
  #    * That sec will be negative if the angle is negative and deg == 0 && min == 0
  # @param [#to_f,#to_degrees] angle may be anything that has a to_f and to_radians.
  # @param [true,false, :radians] radians Angle is in degrees unless radians == true (or set to :radians).
  def self.dms(angle, radians = false)
    ongle = angle.to_f #means Strings, Numeric, and anything accepting a #to_f will work.
    angle = angle.to_degrees if radians == true || radians == :radians
    v = angle.abs
    deg = v.floor
    min = ((v-deg)*60.0).floor
    sec = ((v-deg-min/60.0)*3600.0)

    if angle < 0
      if deg == 0
        if min == 0
          sec = -sec
        else
          min = -min
        end
      else
        deg = -deg
      end
    end

    return deg,min,sec
  end

  #Class level function equivalent to Angle.new(r, true)
  # @return [Angle]
  # @param [#to_f] r Value in radians to create the new Angle class with.
  def self.radians(r=0) #passed in radians.
    self.new(r.to_f, true) #Nb. self is Angle, be we don't Angle.new, as we want subclasses to return their class, not Angle.
  end

  #Class level function equivalent to Angle.new(d, false) or just Angle.new(d)
  # @return [Angle]
  # @param [#to_radians] d Angle to convert to radians, to create new Angle object from.
  def self.degrees(d=0) #passed in degrees.
    self.new(d.to_radians, true)
  end

  #Provides test for Module Comparable, giving us <,>,<=,>=,== between angles
  # @return [true,false]
  # @param [Angle,Float] angle Can be another Angle, or a Numeric value to compare @angle with.
  def <=>(angle)
    if angle.class == Angle
      @angle <=> angle.angle
    else
      @angle <=> angle
    end
  end

  #unary +
  # @return [Angle,self] equivalent to @angle
  def +@
    self.class.radians(@angle) #Nb. Not Angle.new, as we want subclasses to return their class, not Angle.
  end

  #Unary -
  # @return [Angle,self] -@angle
  def -@
    self.class.radians(-@angle)
  end

  # Binary addition operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def +(angle)
    self.class.radians(@angle + angle)
  end

  # Binary subtraction operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def -(angle)
    self.class.radians(@angle - angle)
  end

  # Binary multiply operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def *(angle)
    self.class.radians(@angle * angle)
  end

  # Binary power of operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def **(angle)
    self.class.radians(@angle ** angle)
  end

  # Binary division operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def /(angle)
    self.class.radians(@angle / angle)
  end

  # Binary mod operator. Can add angles and numbers, or two angles.
  # @return [Angle,self]
  # @param [Angle,Numeric] angle
  def %(angle)
    self.class.radians(@angle % angle)
  end

  # @return [Float] angle in degrees
  def to_degrees
    @angle.to_degrees
  end

  # @return [Float] angle in degrees
  #alias to_deg to_degrees
  alias to_deg to_degrees

  # @return [Float]  angle in radians
  def to_radians
    @angle
  end

  alias to_rad to_radians
  alias to_r to_radians

  # Returns @angle as decimal_degrees
  # @return [Array]  of signed Floats: degrees,minutes,seconds
  #Nb. * That min will be negative if the angle is negative and deg == 0
  #    * That sec will be negative if the angle is negative and deg == 0 && min == 0
  def to_dms
    d = to_degrees.abs
    deg = d.floor
    min = ((d-deg)*60).floor
    sec = ((d-deg-min/60.0)*3600.0)

    if @angle < 0
      if deg == 0
        if min == 0
          sec = -sec
        else
          min = -min
        end
      else
        deg = -deg
      end
    end

    return deg, min, sec
  end

  # @return [Float] the angle in radians as a float (equivalent to to_radians)
  alias to_f to_radians

  # @return [Fixnum] the angle truncated to an integer, in radians.
  def to_i
    to_radians.to_i
  end

  # @return [Fixnum] the angle truncated to an integer, in radians.
  alias to_int to_i

  # @return [Array] the angle parameter as a Float and the @angle parameter from this class.
  # @param [Numeric] angle
  def coerce(angle)
    [Float(angle), @angle]
  end

  # @return [Fixnum] the sign of the angle. 1 for positive, -1 for negative.
  def sign
    @angle.sign
  end

  # @return [Float] the absolute angle of the angle in radians
  def abs
    @angle.abs
  end

  # @return [Float] angle as compass bearing in radians.
  #Compass bearings are clockwise, Math angles are counter clockwise.
  def to_bearing
    self.class.new(Math::PI * 2 - @angle,true)
  end

  # @return [Float] the reverse angle in radians. i.e. angle + PI (or angle + 180 degrees)
  def reverse
    if (angle = @angle + Math::PI) > Math::PI * 2
      angle -= Math::PI * 2
    end
    return self.class.new(angle,true)
  end


  # @return [String] angle in radians as a string.
  # @param [String] fmt Optional format string passed to Angle#strf
  def to_s(fmt = nil)
    return to_radians.to_s if(fmt == nil)
    return strf(fmt)
  end

  #formated output of the angle.
  # @param [String] fmt The default format is a signed deg minutes'seconds" with leading 0's in the minutes and seconds and 4 decimal places for seconds.
  #formats are:
  # * %wd output the degrees as an integer.
  # **   where w is 0, 1, 2 or 3 and represents the field width.
  # *** 1 is the default, which indicates that at least 1 digit is displayed
  # *** 2 indicates that at least 2 digits are displayed. 1 to 9 will be displayed as 01 0 to 09 0
  # *** 3 indicates that at least 4 digits are displayed. 10 to 99 will be displayed as 010 0 to 099 0
  #
  # * %w.pD outputs degrees as a float.
  #     * p is the number of decimal places.
  #
  # * %wm output minutes as an integer.
  #     * where the width w is 0, 1 , 2 with similar meaning to %d. p is again the number of decimal places.
  #
  # * %w.pM outputs minutes as a float .e.g. 01.125'.
  #     * p is the number of decimal places.
  #
  # * %wW outputs secs/60 as a float without the leading '0.'.
  #       Used with %m like this %2m'%4W , to get minute marker before the decimal places.
  #       e.g. -37 001'.1167 rather than -37 001.1167'
  #     * p is the number of decimal places.
  #
  # * %w.ps output seconds as a float.
  #     * where the width w is 1 , 2 with similar meaning to %d. p is again the number of decimal places.
  #
  # * %N outputs N if the angle is positive and S if the angle is negative.
  #
  # * %E outputs E if the angle is positive and W if the angle is negative.
  #
  # * %r outputs Radians
  #
  # * %% outputs %
  #
  # Other strings in the format are printed as is.
  # @return [String]
  def strf(fmt="%d %2m'%2.4s\"")
    tokens = fmt.scan(/%[0-9\.]*[%dmsDMNErW]|[^%]*/)
    have_dir = have_dms = false
    tokens.collect! do |t|
      if t[0,1] == '%' #format
        had_dot = false
        decimals = -1
        width = -1
        format = nil
        t[1..-1].scan(/[0-9]+|\.|[0-9]+|[%dmsDMNErW]/) do |t2|
          case t2
            when  /[0-9]+/
              if had_dot
                decimals = t2.to_i
              else
                width = t2.to_i
              end
            when '%'
              format = t2
            when /[dmsMwW]/
              have_dms = true
              format = t2
            when /[NE]/
              have_dir = true
              format = t2
            when '.'
              had_dot = true
            when /[Dr]/
              format = t2
            else
              raise "unknown format character '#{t2}'" #shouldn't be able to get here.
          end
        end
        [:format, width, decimals, format]
      else
        [:filler, t]
      end
    end

    deg,min,sec = to_dms if have_dms

    s = ""
    tokens.each do |t|
      if(t[0] == :format)
        case t[3]
        when '%'
          s += '%'
        when 'd'
          s += s_int(deg, t[1], have_dir)
        when 'D'
          s += s_float(@angle.to_deg, t[1], t[2], have_dir)
        when 'm'
          s += s_int(min, t[1], have_dir)
        when 'M'
          s += s_float(min + sec/60, t[1], t[2], have_dir)
        when 'W'
          s += s_only_places(sec/60,  t[1])
        when 's'
          s += s_float(sec, t[1], t[2], have_dir)
        when 'r'
          s += s_float(@angle, t[1], t[2], have_dir)
        when 'N'
          s +=  (@angle < 0 ? 'S' : 'N')
        when 'E'
          s += (@angle < 0 ? 'W' : 'E')
        end
      else
        s += t[1] #the fillers.
      end
    end

    return s
  end

  private
  #Output angle_dec as a string to the number of decimal places specified by places.
  #Assumes the angle is 0 <= angle_dec < 1
  #No leading '0' is output. The string starts with a '.' if places is non-zero.
  #If ploces is -1, then all decimal places are returned.
  # @return [String]
  # @param [Float] angle_dec Angle's fractional part
  # @param [Fixnum] places Number of decimal places to output
  def s_places(angle_dec, places)
    if places != -1
      places > 0 ? ".%0#{places}d" % (angle_dec * 10 ** places).round : ''
    else
      angle_dec.to_s[1..-1] #Output all decimal places stripping the leading 0
    end
  end

  #return the angle as a string with fixed width decimal portion with leading 0s
  #to get at least the width specified
  #Prints the number of places after the decimal point rounded to places places.
  #-1 width means no width format
  #-1 places means print all decimal places.
  #abs means print the absolute value.
  # @return [String]
  # @param [Float] angle In radians
  # @param [Fixnum] width Output field width, padded with leading 0's
  # @param [Fixnum] places Number of decimal places to output
  # @param [true,false] abs Output absolute value.
  def s_float(angle, width, places, abs)
    angle_int, angle_dec = angle.abs.divmod(1)
    f = "%0#{width > 0 ? width : ''}d"
    s = (abs == false && angle.sign == -1) ? '-' : ''  #catch the case of -0
    s += f % angle.abs + s_places(angle_dec, places)
  end

  #Return the integer part of angle as a string of fixed width
  #If abs == true, then return the absolute value.
  # @return [Fixnum]
  # @param [Float] angle In radians
  # @param [Fixnum] width Output field width, padded with leading 0's
  # @param [true,false] abs Output absolute value.
  def s_int(angle, width, abs)
    f = "%0#{width > 0 ? width : ''}d"
    s = (abs == false && angle.sign == -1) ? '-' : ''  #catch the case of -0
    s += f % angle.abs
  end

  #Return the fractional part of angle as a string,
  #to the number of decimal places specified by 'places'.
  #No leading '0' is output. The string starts with a '.'
  #If ploces is -1, then all decimal places are returned.
  # @return [String]
  # @param [Float] angle In radians
  # @param [Fixnum] places Number of decimal places to output
  def s_only_places(angle, places)
    angle_int, angle_dec = angle.abs.divmod(1)
    s_places(angle_dec, places)
  end
end
