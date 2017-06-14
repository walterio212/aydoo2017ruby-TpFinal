require_relative '../model/persistor'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'


class ValidadorEvento

  def initialize(persistor = Persistor.new())
    @persistor = persistor
  end

  def validar_crear_evento(evento)

    nombreCalendario = evento.getCalendario()
    id = evento.getId()
    nombreEvento = evento.getNombre()

    validar_nombre_calendario_no_vacio(nombreCalendario)
    validar_calendario_existente(nombreCalendario)
    validar_id_evento_ya_existente(id)
    validar_coherencia_fechas(evento)

  end

  def validar_modificar_evento(evento)
    #TODO
  end

  def validar_borrar_evento(evento)
    #TODO
  end


  def validar_calendario_existente(nombreCalendario)
    if(@persistor.existe_calendario?(nombreCalendario.downcase))
      raise CalendarioNombreExistenteError.new()
    end
  end

  def validar_coherencia_fechas(evento)

    fechaInicio = evento.getInicio().to_time.utc
    fechaFin = evento.getFin().to_time.utc

    #chequeo que la fecha de fin no sea menor o igual a la de inicio
    if(fechaFin<=fechaInicio)
      raise EventoFechasIncoherentesError.new()
    end

    #chequeo que la diferencia entre la fecha final y la inicial no sea mayor a 72 horas
    if (fechaFin - fechaInicio).to_i > 3 #dias
      raise EventoDuracionMaximaInvalidaError.new()
    end

    #chequeo que no se superponga con ningun otro evento

    arrayEventos = @persistor.listar_eventos_por_calendario(nombreCalendario.downcase)

    arrayEventos.each do |evento|
      if(evento.periodo_dentro_de_Evento?)
        raise EventoYaExistenteEnCalendarioError.new()
      end
    end

  end

  #TESTEADOS

  #Excepcion si el evento ya existe, true si la validacion fue exitosa
  def validar_id_evento_ya_existente(id)

    arrayEventos = @persistor.listar_todos_los_eventos

    arrayEventos.each do |evento|
      if(evento.getId()==id)
        raise EventoIdYaExistenteError.new()
      end
    end

    true
  end

  def validar_nombre_evento_ya_existente_en_calendario(nombreCalendario,nombreEvento)
    arrayEventos = @persistor.listar_eventos_por_calendario(nombreCalendario.downcase)

    if(! arrayEventos.empty?)
      arrayEventos.each do |evento|
        if evento.getNombre() == nombreEvento
          raise EventoYaExistenteEnCalendarioError.new()
        end
      end
    end

    true
  end


  def validar_nombre_calendario_no_vacio(nombreCalendario)
    if(nombreCalendario.to_s == "")
      raise CalendarioSinNombreError.new()
    end
  end

end