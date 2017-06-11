class CalendarioSinNombreError < StandardError
  def initialize(msg="El calendario ingresado posee el nombre vacio")
  end
end