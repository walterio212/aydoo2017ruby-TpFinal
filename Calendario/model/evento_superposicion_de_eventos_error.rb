class EventoSuperposicionDeEventosError < StandardError
  def initialize(msg="El evento recibido se superpone con otro evento existente")
    super
  end
end