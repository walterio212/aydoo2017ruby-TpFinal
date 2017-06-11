class WebResponse

  def initialize(content_type, estado, respuesta)
    @content_type = content_type
    @estado = estado
    @respuesta = respuesta
  end

  def getContentType()
    @content_type
  end

  def getEstado()
    @estado
  end

  def getRespuesta()
    @respuesta
  end

  def setContentType (value)
    @content_type = value
  end

  def setEstado (value)
    @estado = value
  end

  def setRespuesta (value)
    @respuesta = value
  end
end