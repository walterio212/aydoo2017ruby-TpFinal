class EventoYaExistenteError < StandardError
  def initialize(msg="El id de este evento ya existe")
    super
  end
end