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
    {"frecuencia"=>@frecuencia,"fin"=>@fin}
  end
  
end
