
class EventoIdYaExistenteError < StandardError
  def initialize(msg="El id del nuevo evento ya fue utilizado")
    super
  end
end