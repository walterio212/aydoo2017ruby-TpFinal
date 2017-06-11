class CalendarioInexistenteError < StandardError
  def initialize(msg="El nombre de calendario ingresado no existe")
    super
  end
end