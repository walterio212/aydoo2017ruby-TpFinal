class CalendarioNombreExistenteError < StandardError
  def initialize(msg="Ya existe un calendario con el nombre ingresado")
    super
  end
end