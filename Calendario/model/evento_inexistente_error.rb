class EventoInexistenteError < StandardError
  def initialize(msg="El evento que intenta borrar no existe")
    super
  end
end
