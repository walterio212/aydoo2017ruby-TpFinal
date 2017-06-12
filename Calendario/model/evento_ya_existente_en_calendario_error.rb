
class EventoYaExistenteEnCalendarioError < StandardError
  def initialize(msg="Un evento con este nombre ya existe en este calendario.")
    super
  end
end