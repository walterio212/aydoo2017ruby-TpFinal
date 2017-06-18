require 'date'
require_relative '../model/evento'

class EventoNoRecurrente < Evento

  def periodo_dentro_de_Evento?(fechainicio, fechafin)
    if(fecha_ocupada?(fechainicio) || fecha_ocupada?(fechafin))
      return true
    end

    return fechainicio.to_time.utc <= getInicio().to_time.utc && getFin().to_time.utc <= fechafin.to_time.utc
  end

  def fecha_ocupada?(fecha)
    inicioUtc = getInicio().to_time.utc
    finUtc = getFin().to_time.utc

    fechaUtc = fecha.to_time.utc
    estaOcupada = fechaUtc.between?(inicioUtc,finUtc)
    
    estaOcupada
  end

end
