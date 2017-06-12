class ActualizadorEvento
  def initialize(id,inicio,fin)
    @id = id
    @inicio = inicio
    @fin = fin   
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
end