require 'date'

class EventoAnual < Evento

  def periodo_dentro_de_Evento?(fechainicio, fechafin)
    if(fecha_ocupada?(fechainicio) || fecha_ocupada?(fechafin))
      return true
    end

    return fechainicio.to_time.utc <= getInicio().to_time.utc && getFin().to_time.utc <= fechafin.to_time.utc
  end

  def fecha_ocupada?(fecha)
    inicioUtc = getInicio().to_time.utc
    finUtc = getFin().to_time.utc
    finRecurrenciaUtc = getRecurrencia().getFin().to_time.utc

    estaOcupada = false
    fechaUtc = fecha.to_time.utc
    iteraciones = 1

    while finUtc < finRecurrenciaUtc && !estaOcupada do
      if(inicioUtc < fechaUtc && fechaUtc < finUtc)
        estaOcupada = true
      end

      inicioUtc = (getInicio() + (365 * iteraciones)).to_time.utc
      finUtc = (getFin() + (365 * iteraciones)).to_time.utc

      iteraciones += 1
    end

    estaOcupada
  end
end