require_relative '../model/evento_diario'
require_relative '../model/evento_semanal'
require_relative '../model/evento_mensual'
require_relative '../model/evento_anual'
require_relative '../model/evento_no_recurrente'

class EventoBuilder

  TipoEventos = Hash[
    "diaria" => EventoDiario,
    "semanal" => EventoSemanal,
    "mensual" => EventoMensual,
    "anual" => EventoAnual,
    "norecurrente" => EventoNoRecurrente
  ]

  def crear (evento_json)

    #Creo la recurrencia (Por la recurrencia voy a decidir que tipo de objeto es)
    recurrencia = crear_recurrencia(evento_json["recurrencia"])

    #obtengo el resto de la informacion
    inicio = evento_json["inicio"]
    fin = evento_json["fin"]
    fecha_inicio = DateTime.strptime(inicio,"%Y-%m-%dT%H:%M:%S%z")
    fecha_fin = DateTime.strptime(fin,"%Y-%m-%dT%H:%M:%S%z")

    #busco en el diccionario que tipo de evento esta asociado con esa recurrencia y lo creo en funcion de eso
    tipo_de_evento = TipoEventos[recurrencia.getFrecuencia]
    return tipo_de_evento.new(evento_json["calendario"],evento_json["id"],evento_json["nombre"],fecha_inicio,fecha_fin,recurrencia)

  end

  def crear_recurrencia(recurrencia)

    nuevaRecurrencia = nil
    if(recurrencia.nil?)
      nuevaRecurrencia = Recurrencia.new("norecurrente", nil)
    else
      nuevaRecurrencia = Recurrencia.new(recurrencia["frecuencia"],DateTime.parse(recurrencia["fin"]).to_date)
    end

  end

  def recrear_evento(evento, actualizador)
    frecuenciaNueva = actualizador.getRecurrencia().getFrecuencia()
    inicio = actualizador.getInicio().nil? ? evento.getInicio() : actualizador.getInicio()
    fin = actualizador.getFin().nil?       ? evento.getFin() : actualizador.getFin()

    tipo_de_evento = TipoEventos[frecuenciaNueva]

    return tipo_de_evento.new(evento.getCalendario(), evento.getId(), evento.getNombre(), inicio, fin, recurrencia)
  end

end