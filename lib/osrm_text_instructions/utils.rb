module OSRMTextInstructions
  module Utils
    def self.get_direction_from_degree(degree)
      if degree >= 340 || degree <= 20
        ['north', 'N']
      elsif degree > 20 && degree < 70
        ['northeast', 'NE']
      elsif degree >= 70 && degree < 110
        ['east', 'E']
      elsif degree >= 110 && degree <= 160
        ['southeast', 'SE']
      elsif degree > 160 && degree <= 200
        ['south', 'S']
      elsif degree > 200 && degree < 250
        ['southwest', 'SW']
      elsif degree >= 250 && degree <= 290
        ['west', 'W']
      elsif degree > 290 && degree < 340
        ['northwest', 'NW']
      else
        raise "Degree #{degree} invalid"
      end
    end
  end
end
