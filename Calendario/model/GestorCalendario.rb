require_relative '../model/GeneralError'
require_relative '../model/calendario'
require_relative '../model/convertidor_json_objeto'
require_relative '../model/Persistidor'

class GestorCalendario

  def initialize()
    @persistor = Persistidor.new(File, Dir)
    @conversor = ConvertidorJsonObjeto.new()
  end

  def crearCalendario(jsonCalendario)
    puts jsonCalendario
    calendario = @conversor.convertirCalendario(jsonCalendario)[0]
    @persistor.crearCalendario(calendario)
  end

end