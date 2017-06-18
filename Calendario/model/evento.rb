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
  
  def setInicio(inicio)
    @inicio = inicio
  end
  
  def setFin(fin)
    @fin = fin
  end

  def setRecurrencia(recurrencia) 
    @recurrencia = recurrencia
  end
  
  def getRecurrencia()
    @recurrencia
  end

  def to_json
    {"calendario"=>@calendario,"id"=>@id,"nombre"=>@nombre,"inicio"=>@inicio,"fin"=>@fin,"recurrencia"=>@recurrencia.to_json}
  end
  
end
