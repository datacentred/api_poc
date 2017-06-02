module Harbour
  module Sortable
    def sort_alphabetically(enum)
      if enum.is_a?(Array)
        enum.each_with_index do |element, i|
          if element.is_a? Enumerable
            enum[i] = sort_alphabetically(element)
          end
        end
        enum = enum.sort rescue enum
        enum = enum.sort_by{|u| u[:name]} rescue enum
        enum = enum.sort_by{|u| u[:recorded_at]} rescue enum
        return enum
      elsif enum.is_a?(Hash)
        enum.each do |k,v|
          if v.is_a? Enumerable
            enum[k] = sort_alphabetically(v)
          end
        end
        return Hash[enum.sort]
      else
        enum
      end
    end
  end
end
