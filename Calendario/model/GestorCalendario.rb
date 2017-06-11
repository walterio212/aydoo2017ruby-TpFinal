require 'json'
require_relative '../model/GeneralError'
require_relative '../model/calendario'
require_relative '../model/convertidor_json_objeto'
require_relative '../model/convertidor_objeto_json'
require_relative '../model/validador_calendario'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'
require_relative '../model/persistor'
require_relative '../model/web_response'

class GestorCalendario

  def initialize(
      persistor = Persistor.new(File, Dir), 
      convertidorJsonObjeto = ConvertidorJsonObjeto.new(), 
      convertidorObjetoJson = ConvertidorObjetoJson.new(),
      validadorCalendario = ValidadorCalendario.new()
      )
    @persistor = persistor
    @conversorJsonObjeto = convertidorJsonObjeto  
    @conversorObjetoJson = convertidorObjetoJson
    @validadorCalendario = validadorCalendario
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
      calendario = @persistor.obtener_calendario(nombreCalendario)
      webResponse.setRespuesta(calendario)
    rescue CalendarioInexistenteError => e 
      webResponse.setEstado(404)
      webResponse.setRespuesta(e.message)
    end

    webResponse
  end

  def crearEvento(jsonEvento)
    webResponse = WebResponse.new("", 200, "")
    evento = @conversorJsonObjeto.convertir_evento_no_array(jsonEvento)
    @persistor.crear_evento(evento)

    webResponse
  end

  def borrarCalendario(nombreCalendario)
    @persistor.borrar_calendario(nombreCalendario)
  end

  def listarTodosLosCalendarios()
    calendarios = @persistor.listar_todos_los_calendarios()
    JSON.dump(@conversorObjetoJson.convertir_calendarios(calendarios))
  end
end