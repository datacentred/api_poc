module Harbour
  module Utc
    def convert_dates_to_utc(enum)
      time_format = /^\d\d\d\d\-\d\d\-\d\dT\d\d:\d\d:\d\d.*$/
      
      if enum.is_a?(Array)
        enum.each_with_index do |element, i|
          if element.is_a?(Time) || element =~ time_format
            enum[i] = Time.parse(element.to_s).utc.iso8601 rescue element
          elsif element.is_a? Enumerable
            enum[i] = convert_dates_to_utc(element)
          end
        end
      elsif enum.is_a?(Hash)
        enum.each do |k,v|
          if v.is_a?(Time) || v =~ time_format
            enum[k] = Time.parse(v.to_s).utc.iso8601 rescue v
          elsif v.is_a? Enumerable
            enum[k] = convert_dates_to_utc(v)
          end
        end
      end
      enum
    end
  end
end
