
class EventoFechasIncoherentesError < StandardError
  def initialize(msg="Las fechas del evento recibidas no son coherentes. Por favor reviselas.")
    super
  end
end