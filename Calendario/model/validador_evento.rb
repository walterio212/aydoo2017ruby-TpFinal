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
    recurrencia = evento.getRecurrencia()

    #todo validaciones
    validar_nombre_calendario_no_vacio(nombreCalendario)
    validar_calendario_existente(nombreCalendario)
    #validar_id_evento_ya_existente(nombreCalendario,id)
    validar_nombre_evento_inexistente_en_calendario(nombreCalendario,nombreEvento)
    validar_coherencia_fechas(evento)
    #valudar_recurrencia(recurrencia)

  end

  private

  def validar_nombre_calendario_no_vacio(nombreCalendario)
    if(nombreCalendario.to_s == "")
      raise CalendarioSinNombreError.new()
    end
  end

  def validar_calendario_existente(nombreCalendario)
    if(@persistor.existe_calendario?(nombreCalendario.downcase))
      raise CalendarioNombreExistenteError.new()
    end
  end

  def validar_id_evento_ya_existente(nombreCalendario,id)
    #TODO aca estaria bueno tener un metodo que me devuelva todos los eventos de todos os calendarios. lo haria pero no quiero tocar clases q tocaste vos sin prruntar antes
    arrayEventos = @persistor.listar_eventos_por_calendario(nombreCalendario.downcase)

    if(! arrayEventos.empty?)
      arrayEventos.each do |evento|
        if(evento.getId() == id)
          raise EventoYaExistenteError.new()
        end
      end
    end
  end

  def validar_nombre_evento_ya_existente_en_calendario(nombreCalendario,nombreEvento)
    arrayEventos = @persistor.listar_eventos_por_calendario(nombreCalendario.downcase)

    if(! arrayEventos.empty?)
      arrayEventos.each do |evento|
        if(evento.getNombre()) == nombreEvento)
          raise EventoYaExistenteEnCalendarioError.new()
        end
      end
    end
  end

  def validar_coherencia_fechas(evento)

    fechaInicio = evento.getInicio()
    fechaFin = evento.getFin()

    arrayEventos = @persistor.listar_eventos_por_calendario(nombreCalendario.downcase)

    if(! arrayEventos.empty?)
      arrayEventos.each do |evento|
        if(evento.getId() == id)
          raise EventoYaExistenteEnCalendarioError.new()
        end
      end
    end
  end

end