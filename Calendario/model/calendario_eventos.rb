class CalendarioEventos

  def initialize(calendario, eventos)
    @calendario = calendario
    @eventos = eventos
  end

  def to_json() 
    {"calendario" => @calendario.to_json, "eventos" => eventosArrayJson}
  end

  private

  def eventosArrayJson() 
    array = []

    @eventos.each { |evento| array << evento.to_json() }

    array
  end

end