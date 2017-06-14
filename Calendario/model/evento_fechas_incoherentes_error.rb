
class EventoFechasIncoherentesError < StandardError
  def initialize(msg="Las fechas del evento recibidas no son coherentes. Por ")
    super
  end
end