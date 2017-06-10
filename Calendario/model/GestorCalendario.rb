require_relative '../model/GeneralError'
require_relative '../model/calendario'
require_relative '../model/convertidor_json_objeto'
require_relative '../model/Persistidor'

class GestorCalendario

  def initialize()
    @persistor = Persistor.new(File, Dir)
    @conversor = ConvertidorJsonObjeto.new()    
  end

  def crearCalendario(jsonCalendario)
    puts jsonCalendario
    calendario = @conversor.convertir_calendario(jsonCalendario)[0]
    @persistor.crearCalendario(calendario)
  end

  def obtenerCalendario(nombreCalendario)
    calendario = @persistor.obtenerCalendario(nombreCalendario)
  end

  def borrarCalendario(nombreCalendario)
    @persistor.borrarCalendario(nombreCalendario)
  end


end