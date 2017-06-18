require_relative '../model/persistor'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'
require_relative '../model/evento_calendario_no_existente_error'


class ValidadorEvento

  def initialize(persistor = Persistor.new())
    @persistor = persistor
  end

  def validar_modificar_evento(evento)
    #TODO

    #exista el evento
    #superposicion de fechas
    #(obtener evento por id, fichando las fechas por las que vengan que no sean null)
  end

  def validar_existe_evento?(id)

    arrayEventos = @persistor.listar_todos_los_eventos()

    arrayEventos.each do |evento|
      if(evento.getId()==id)
        return true
      end
    end

    raise EventoInexistenteError.new()
  end

  def validar_id_evento_ya_existente(id)

    arrayEventos = @persistor.listar_todos_los_eventos()

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

    true
  end


  def validar_calendario_existente(nombreCalendario)
    if(! @persistor.existe_calendario?(nombreCalendario.downcase))
      raise EventoCalendarioNoExistenteError.new()
    end
    true
  end

  def validar_fecha_fin_posterior_fecha_inicio(evento)
    fechaInicio = evento.getInicio().to_time.utc
    fechaFin = evento.getFin().to_time.utc

    if(fechaInicio>=fechaFin)
      raise EventoFechasIncoherentesError.new()
    end

    true
  end

  def validar_duracion_evento_permitida(evento) #3 dias maximo
    fechaInicio = evento.getInicio().to_time.utc
    fechaFin = evento.getFin().to_time.utc

    if (fechaFin - fechaInicio).to_i > 86400*3 #dias
      raise EventoDuracionMaximaInvalidaError.new()
    end

    true
  end

  def validar_no_superposicion_de_eventos(eventoAValidar)

      arrayEventos = @persistor.listar_eventos_por_calendario(eventoAValidar.getNombre.downcase)

    arrayEventos.each do |evento|
      if(evento.periodo_dentro_de_Evento?(eventoAValidar.getInicio(),eventoAValidar.getFin()))

        raise EventoSuperposicionDeEventosError.new()

      end
    end

    true

  end

end