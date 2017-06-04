require 'json'  #Libreria para parseo de JSON
require_relative 'calendario'

class ConvertidorJsonObjeto

  def convertirCalendario(json)
    
    respuesta = nil;
    
    if json.nil? || json.empty?
      return respuesta
    end
  
    respuesta = []
  
    json_parseado = JSON.parse(json);
    
    json_parseado.each { |calendario_json| respuesta << Calendario.new(calendario_json["nombre"]) }
    
    return respuesta
  
  end

end
