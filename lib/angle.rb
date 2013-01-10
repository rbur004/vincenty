#Class Angle is a utility class that allows 
# * Angle arithmetic
# * Angle comparison
# * Conversion to and from degrees and radians
# * Conversion to string as radians or DMS format

require 'core_extensions.rb'

class Angle
  include Comparable
  
  #Provides test for Module Comparable
  def <=>(v)
    if v.class == Angle
      @value <=> v.value
    else 
      @value <=> v
    end
  end

  attr_accessor :value #stored in radians
  
  #v may be anything that has a to_f and to_radians. The Default for v is degrees.
  #if radians == true then v is in radians, not degrees.
  def initialize(v=0, radians=false)
    #assumes that we are getting a value in degrees.
    if radians
      @value = v.to_f #works for String, Fixed, other Angles and for Float.
    else
      if v.class == Array
        @value = self.class.decimal_deg(*v).to_radians #Wild assumption that the array is deg,min,sec.
      else
        @value = v.to_radians #we have a String and Numeric class version of this. Another Angle will work too.
      end
    end
  end
  
  #Class level function that converts an array of up to 4 values into decimal degrees.
  #a[0..3] is degrees, minutes, seconds, direction. Dircection is one of 'N', 'S', 'E', 'W'.
  #nil values in the array are set to 0
  #if the a.length < 4,t then a is extended to be length 4 with 0
  #A 0 as the direction has no effect on the sign of the result
  #Returns: signed decimal degress.
  def self.decimal_deg(*a)
    (0..3).each { |x|  a[x] = 0 if a[x] == nil } #convert nil arguments to 0 and ensure 4 values.
    s = { 'N'=>1, 'S'=>-1, 'E'=>1, 'W'=>-1, 0=>1 }
    a[0].sign * (a[0].abs + a[1]/60.0 + a[2]/3600.0) * s[a[3]]
  end
  
  #Class level utility function to return the value as deg,min,sec
  #Assumes decimal degress unless radians == true
  #returns an array of signed deg, min, sec.
  def self.dms(v, radians = false)
    v = v.to_d if radians
    deg = v.floor
    min = ((v-@deg)*60).floor
    sec = ((v-@deg-min/60.0)*3600.0) 
    
    if v < 0 &&  deg == 0
      if min == 0
        sec = -sec
      else
        min = -min 
      end
    end
    return deg,min,sec
  end
     
  #Class level function equivalent to Angle.new(r, true)
  #Returns: new Angle
  def self.radians(r=0) #passed in radians.
    self.new(r.to_f, true) #Nb. self is Angle, be we don't Angle.new, as we want subclasses to return their class, not Angle.
  end
  
  #Class level function equivalent to Angle.new(d, false) or just Angle.new(d)
  #Returns: new Angle
  def self.degrees(d=0) #passed in degrees.
    self.new(d.to_radians, true)
  end
    
  #unary +
  #Returns: new Angle
  def +@
    self.class.radians(@value) #Nb. Not Angle.new, as we want subclasses to return their class, not Angle.
  end
  
  #Unary -
  #Returns: new Angle
  def -@
    self.class.radians(-@value)
  end
  
  #Returns :new Angle
  def +(v)
    self.class.radians(@value + v)
  end
  
  #Returns: new Angle
  def -(v)
    self.class.radians(@value - v)
  end
    
  #Returns :new Angle
  def *(v)
    self.class.radians(@value * v)
  end
  
  #Returns: new Angle
  def **(v)
    self.class.radians(@value ** v)
  end
  
  #Returns: new Angle
  def /(v)
    self.class.radians(@value / v)
  end
  
  #Returns: new Angle
  def %(v)
    self.class.radians(@value % v)
  end
    
  #Returns: angle in degrees
  def to_degrees
    @value.to_degrees
  end
 
  alias to_d to_degrees
  
  #Returns: angle in radians
  def to_radians
    @value
  end

  alias to_r to_radians
  
  #Returns: [deg,min,sec]
  #Nb. * That min will be negative if the angle is negative and deg == 0
  #    * That sec will be negative if the angle is negative and deg == 0 && min == 0
  def to_dms 
    d = to_degrees.abs
    deg = d.floor
    min = ((d-deg)*60).floor
    sec = ((d-deg-min/60.0)*3600.0) 
    
    if @value < 0
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
  
  #Returns: the angle in radians as a float (equivalent to to_radians)
  alias to_f to_radians
  
  #Returns the angle truncated to an integer, in radians.
  def to_i
    to_radians.to_i
  end
  
  alias to_int to_i
  
  def coerce(v)
    [Float(v), @value]
  end
  
  #Returns: the sign of the angle. 1 for positive, -1 for negative.
  def sign
    @value.sign
  end
  
  #Returns: the absolute value of the angle in radians
  def abs
    @value.abs
  end
  
  #Returns: angle as compass bearing in radians.
  #Compass bearings are clockwise, Math angles are counter clockwise.
  def to_bearing
    self.class.new(Math::PI * 2 - @value,true)
  end
  
  #Returns: the reverse angle in radians. i.e. angle + PI (or angle + 180 degrees)
  def reverse
    if (v = @value + Math::PI) > Math::PI * 2
      v -= Math::PI * 2
    end
    return self.class.new(v,true)
  end
  
  
  #Returns: angle in radians as a string.
  def to_s(fmt = nil)
    return to_radians.to_s if(fmt == nil)
    return strf(fmt)
  end
  
  #formated output of the angle.
  #The default format is a signed deg^0minutes'seconds'' with leading 0's in the minutes and seconds and 4 decimal places for seconds.
  #formats are:
  # * %wd output the degrees as an integer.
  # **   where w is 0, 1, 2 or 3 and represents the field width. 
  # *** 1 is the default, which indicates that at least 1 digit is displayed
  # *** 2 indicates that at least 2 digits are displayed. 1 to 9 will be displayed as 01^0 to 09^0
  # *** 3 indicates that at least 4 digits are displayed. 10 to 99 will be displayed as 010^0 to 099^0
  #
  # * %w.pD outputs degrees as a float.
  # ** p is the number of decimal places.
  #
  # * %wm output minutes as an integer.
  # ** where the width w is 0, 1 , 2 with similar meaning to %d. p is again the number of decimal places.
  #
  # * %w.pM outputs minutes as a float .e.g. 01.125'.
  # ** p is the number of decimal places.
  #
  # * %wW outputs secs/60 as a float without the leading '0.'. 
  #       Used with %m like this %2m'%4W , to get minute marker before the decimal places. 
  #       e.g. -37^001'.1167 rather than -37^001.1167'
  # ** p is the number of decimal places.
  #
  # * %w.ps output seconds as a float.
  # ** where the width w is 1 , 2 with similar meaning to %d. p is again the number of decimal places.
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
  def strf(fmt="%d^0%2m'%2.4s''")
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
          s += s_float(@value.to_d, t[1], t[2], have_dir)
        when 'm'
          s += s_int(min, t[1], have_dir)
        when 'M'
          s += s_float(min + sec/60, t[1], t[2], have_dir)
        when 'W'
          s += s_only_places(sec/60,  t[1])
        when 's'
          s += s_float(sec, t[1], t[2], have_dir)
        when 'r'
          s += s_float(@value, t[1], t[2], have_dir)
        when 'N'
          s +=  (@value < 0 ? 'S' : 'N')
        when 'E'
          s += (@value < 0 ? 'W' : 'E')
        end
      else
        s += t[1] #the fillers.
      end
    end
    
    return s
  end
  
  private 
  def s_places(v, places)
    if places != -1
      dec_p = (v * 10 ** places).round
      f = ".%0#{places > 0 ? places : ''}d"
      f % dec_p
    else
      '.' + v_dec.to_s[2..-1] 
    end
  end

  def s_only_places(v, places)
    v_int, v_dec = v.abs.divmod(1)
    s_places(v_dec, places)
  end

  #Prints fixed width decimal portion with leading 0s to get at least the width specified
  #Prints the number of places after the decimal point rounded to places places.
  #-1 width means no width format
  #-1 places means print all decimal places.
  #abs means print the absolute value.
  def s_float(v, width, places, abs)
    v_int, v_dec = v.abs.divmod(1)
    f = "%0#{width > 0 ? width : ''}d"
    s = (abs == false && v.sign == -1) ? '-' : ''  #catch the case of -0
    s += f % v.abs + s_places(v_dec, places)
  end

  def s_int(v, width, abs)
    f = "%0#{width > 0 ? width : ''}d"
    s = (abs == false && v.sign == -1) ? '-' : ''  #catch the case of -0
    s += f % v.abs
  end
end









