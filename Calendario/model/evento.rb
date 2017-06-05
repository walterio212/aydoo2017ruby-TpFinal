require 'json'

class Evento

  def initialize(calendario,id,nombre,inicio,fin,recurrencia)
    @calendario = calendario
    @id = id 
    @nombre = nombre
    @inicio = inicio
    @fin = fin
    @recurrencia = recurrencia
  end

  def getCalendario()
    @calendario
  end

  def getId()
    @id
  end
  
  def getNombre()
    @nombre
  end
  
  def getInicio()
    @inicio
  end
  
  def getFin()
    @fin
  end
  
  
  def getRecurrencia()
    @recurrencia
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var| 
      hash[var.to_s[1..-1]] = self.instance_variable_get var
    end

    hash.to_json
  end
  
end
