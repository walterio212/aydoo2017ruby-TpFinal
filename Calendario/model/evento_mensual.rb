require 'date'

class EventoMensual < Evento

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
      if(fechaUtc.between?(inicioUtc,finUtc))
        estaOcupada = true
      end

      inicioUtc = (getInicio() >>  iteraciones).to_time.utc
      finUtc = (getFin() >> iteraciones).to_time.utc

      iteraciones += 1
    end

    estaOcupada
  end


#  def dias_del_mes(anio,mes)
#    case mes
#      when 4,5,9,11
#        30
#      when 2
#        (anio%4==0) ? 29 : 28
#      else
3#        31
#    end
#  end
end
