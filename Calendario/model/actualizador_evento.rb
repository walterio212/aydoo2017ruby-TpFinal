class ActualizadorEvento
  def initialize(id,inicio,fin, recurrencia)
    @id = id
    @inicio = inicio
    @fin = fin   
    @recurrencia = recurrencia
  end

  def getInicio()
    @inicio
  end

  def getFin()
    @fin
  end

  def getId()
    @id
  end

  def getRecurrencia() 
    @recurrencia
  end
end