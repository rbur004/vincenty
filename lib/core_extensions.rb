require 'scanf'


# TODO: localize these monkey patches as per
# http://dev.venntro.com/2012/11/ruby-2-0-0-preview-features/
#    ( depends if we want to bump to ruby 2.0 )

#Extends Numeric, hence Fixed & Float to_r & to_d
#Also adds in sign.
class Numeric
  #Convert Radians to Degrees
  # @return [Numeric] degrees
  def to_degrees
    self * 180.0 / Math::PI
  end

  #Converts degrees to Radians
  # @return [Numeric] radians
  def to_radians
    self * Math::PI / 180.0
  end

  alias to_r to_radians
  alias to_rad to_radians
  alias to_deg to_degrees

  # @return [Fixnum] 1 if number is positive, -1 if negative.
  def sign
    self < 0 ? -1 : 1
  end

end

#Extends String to to_dec_degrees, add to_r and to_d
class String
  #string expected to be degrees, returns decimal degrees.
  #common forms are S37 001'7.5'', 37 001'7.5''S , -37 001'7.5'', -37 0 1.512'. -37.01875 0, 37 001'.512S, S37 001'.512, ...
  # @return [Float] angle in decimal degrees
  def to_dec_degrees
    #reorder 37 001'.512S, S37 001'.512 into 37 001.512'S, S37 001.512' respectively
    s = self.gsub(/([0-9])([''])\.([0-9]+)/, '\1.\3\2')
    #add in minutes and seconds to get 3 values 'deg 0 0'from  S37 0, 37 0S
    s.gsub!(/^([^0-9\.\-]*)([0-9\-\.]+)([^0-9\-\.]*)$/, '\1\2\3 0 0\5')
    #add in seconds get 3 values 'deg min 0' from  S37 01.512',  37 01.512'S
    s.gsub!(/^([^0-9\.\-]*)([0-9\-\.]+)([^0-9\-\.]+)([0-9\-\.]+)([^0-9\-\.]*)$/, '\1\2\3\4 0\5')

    #look for anything of the form S37 001'7.5'', S37 01.512', S37.01875 0, ...
    s.scanf("%[NSEW]%f%[^0-9-]%f%[^0-9-]%f") do |direction, deg, sep1, min, sep2, sec|
      return Vincenty::Angle.decimal_deg( deg,  min,  sec,  direction)
    end

    #look for anything of the form 37 001'7.5''S , -37 001'7.5'', -37 0 1.512'. -37.01875 0, ...
    s.scanf("%f%[^0-9-]%f%[^0-9-]%f%[^NSEW]%[NSEW]") do |deg, sep1, min, sep2, sec, sep3, direction|
      return Vincenty::Angle.decimal_deg( deg,  min,  sec,  direction)
    end
  end

  #Convert String number in Radians to Degrees
  # @return [Float]  degrees
  def to_degrees #string expected to be radians, returns degrees
    self.to_f.to_degrees
  end

  #Converts string degrees to to_decimal_degrees, then to Radians
  # @return [Float] radians
  def to_radians #string expected to be degrees, returns radians
    self.to_dec_degrees.to_radians
  end

  alias to_rad to_radians
  alias to_r to_radians
  alias to_deg to_degrees
end
