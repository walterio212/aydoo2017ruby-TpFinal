require 'json'
require_relative '../model/GeneralError'
require_relative '../model/calendario'
require_relative '../model/convertidor_json_objeto'
require_relative '../model/persistor'

class GestorCalendario

  def initialize(persistor = Persistor.new(File, Dir), convertidorJsonObjeto = ConvertidorJsonObjeto.new() )
    @persistor = persistor
    @conversor = convertidorJsonObjeto    
  end

  def crearCalendario(jsonCalendario)
    calendario = @conversor.convertir_calendario(jsonCalendario)[0]
    @persistor.crear_calendario(calendario)
  end

  def obtenerCalendario(nombreCalendario)
    calendario = @persistor.obtener_calendario(nombreCalendario)
  end

  def borrarCalendario(nombreCalendario)
    @persistor.borrar_calendario(nombreCalendario)
  end

  def listarTodosLosCalendarios()
    calendarios = @persistor.listar_todos_los_calendarios()
    JSON.dump(calendarios)
  end
end