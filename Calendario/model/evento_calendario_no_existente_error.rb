class EventoCalendarioNoExistenteError < StandardError
  def initialize(msg="El calendario donde se desea crear el evento no existe.")
    super
  end
end