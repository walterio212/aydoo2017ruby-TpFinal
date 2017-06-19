require 'json'
require_relative '../model/GeneralError'
require_relative '../model/calendario'
require_relative '../model/convertidor_json_objeto'
require_relative '../model/convertidor_objeto_json'
require_relative '../model/validador_evento'
require_relative '../model/validador_calendario'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'
require_relative '../model/evento_calendario_no_existente_error'
require_relative '../model/evento_duracion_maxima_invalida_error'
require_relative '../model/evento_fechas_incoherentes_error'
require_relative '../model/evento_id_ya_existente_error'
require_relative '../model/evento_inexistente_error'
require_relative '../model/evento_superposicion_de_eventos_error'
require_relative '../model/evento_ya_existente_en_calendario_error'
require_relative '../model/persistor'
require_relative '../model/web_response'

class GestorCalendario

  def initialize(
      persistor = Persistor.new(File, Dir), 
      convertidorJsonObjeto = ConvertidorJsonObjeto.new(), 
      convertidorObjetoJson = ConvertidorObjetoJson.new(),
      validadorCalendario = ValidadorCalendario.new(),
      validadorEvento = ValidadorEvento.new(),
      json = JSON
      )
    @persistor = persistor
    @conversorJsonObjeto = convertidorJsonObjeto  
    @conversorObjetoJson = convertidorObjetoJson
    @validadorCalendario = validadorCalendario
    @validadorEvento     = validadorEvento
    @json = json
  end

  def crearCalendario(jsonCalendario)
    webResponse = WebResponse.new("", 200, "")
    begin
      calendario = @conversorJsonObjeto.convertir_calendario_no_array(jsonCalendario)
      @validadorCalendario.validar_crear_calendario(calendario)
      @persistor.crear_calendario(calendario)
    rescue CalendarioNombreExistenteError => e 
      webResponse.setEstado(400)
      webResponse.setRespuesta(e.message)
    rescue CalendarioSinNombreError => e 
      webResponse.setEstado(400)
      webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def obtenerCalendario(nombreCalendario)
    webResponse = WebResponse.new("", 200, "")
    begin
      @validadorCalendario.validar_calendario_existente(nombreCalendario)
      calendario = @persistor.obtener_calendario_eventos(nombreCalendario)
      jsonCalendarioEventos = @json.dump(calendario.to_json())
      webResponse.setRespuesta(jsonCalendarioEventos)
    rescue CalendarioInexistenteError => e 
      webResponse.setEstado(404)
      webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def crearEvento(jsonEvento)
    webResponse = WebResponse.new("", 200, "")
    evento = @conversorJsonObjeto.convertir_evento_no_array(jsonEvento)

    begin

      @validadorEvento.validar_calendario_existente(evento.getCalendario())
      @validadorEvento.validar_duracion_evento_permitida(evento)
      @validadorEvento.validar_fecha_fin_posterior_fecha_inicio(evento)
      @validadorEvento.validar_id_evento_ya_existente(evento.getId())
      @validadorEvento.validar_nombre_evento_ya_existente_en_calendario(evento.getCalendario(),evento.getNombre())
      @validadorEvento.validar_no_superposicion_de_eventos(evento)
      @persistor.crear_evento(evento)

    rescue EventoCalendarioNoExistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoDuracionMaximaInvalidaError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoFechasIncoherentesError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoIdYaExistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoYaExistenteEnCalendarioError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoSuperposicionDeEventosError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def borrarCalendario(nombreCalendario)
    webResponse = WebResponse.new("", 200, "")
    begin 
      @validadorCalendario.validar_calendario_existente(nombreCalendario)
      @persistor.borrar_calendario(nombreCalendario)
    rescue CalendarioInexistenteError => e 
      webResponse.setEstado(404)
      webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def listarTodosLosCalendarios()
    calendarios = @persistor.listar_todos_los_calendarios()
    @json.dump(@conversorObjetoJson.convertir_calendarios(calendarios))
  end

  def listarEventosPorCalendario(nombreCalendario)
    webResponse = WebResponse.new("html", 200, "")
    begin 
      @validadorCalendario.validar_calendario_existente(nombreCalendario)
      eventos = @persistor.listar_eventos_por_calendario(nombreCalendario)
      webResponse.setRespuesta(@json.dump(@conversorObjetoJson.convertir_eventos(eventos)))
      webResponse.setContentType(:json)
    rescue CalendarioInexistenteError => e 
      webResponse.setEstado(404)
      webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def listarTodosLosEventos()
    eventos = @persistor.listar_todos_los_eventos()
    @json.dump(@conversorObjetoJson.convertir_eventos(eventos))
  end

  def obtenerEventoPorId(idEvento)
    evento = @persistor.obtener_evento_por_id(idEvento)
    @json.dump(@conversorObjetoJson.convertir_evento(evento))
  end

  def borrarEvento(idEvento)

    webResponse = WebResponse.new("html", 200, "")

    begin
      @validadorEvento.validar_existe_evento?(idEvento)
      @persistor.borrar_evento(idEvento)

    rescue EventoInexistenteError => e
      webResponse.setEstado(404)
      webResponse.setRespuesta(e.message)

    end

    webResponse
  end

  def modificarEvento(jsonActualizador)

    webResponse = WebResponse.new("html", 200, "")

    begin

      actualizadorEvento = @conversorJsonObjeto.convertir_actualizador(jsonActualizador)
      @validadorEvento.validar_existe_evento?(actualizadorEvento.getId)

      @validadorEvento.validar_recurrencia_actualizador(actualizadorEvento)

      @persistor.modificar_evento(actualizadorEvento)

      rescue EventoCalendarioNoExistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoDuracionMaximaInvalidaError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoFechasIncoherentesError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoIdYaExistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoYaExistenteEnCalendarioError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoInexistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue CalendarioInexistenteError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)
      rescue EventoSuperposicionDeEventosError => e
        webResponse.setEstado(404)
        webResponse.setRespuesta(e.message)

    end

    webResponse
  end
end