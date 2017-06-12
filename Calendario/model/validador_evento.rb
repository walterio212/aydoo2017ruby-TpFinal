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
    nombre = evento.getNombre()
    inicio = evento.getInicio()
    fin = evento.getFin()
    recurrencia = evento.getRecurrencia()

    #todo validaciones
    validar_nombre_calendario_no_vacio(nombreCalendario)
    validar_calendario_existente(nombreCalendario)
    #validar_id_evento_inexistente(id)
    #validar_nombre_evento_inexistente_en_calendario()
    #validar_coherencia_fechas(inicio,fin)
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

end