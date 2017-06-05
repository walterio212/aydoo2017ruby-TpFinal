require 'json'

class Recurrencia

  def initialize(frecuencia,fin)
    @frecuencia = frecuencia
    @fin = fin 
  end

  def getFrecuencia()
    @frecuencia
  end

  def getFin()
    @fin
  end
  
  def to_json
    hash = {}
    self.instance_variables.each do |var| 
      hash[var.to_s[1..-1]] = self.instance_variable_get var
    end

    hash.to_json
  end
  
end
