require 'json'  #Libreria para parseo de JSON

class ConvertidorJsonObjeto

  def convertirCalendario(json)
    
    if json.nil? || json.empty?
      return nil
    end
  
    json_parseado = JSON.parse(json);
    
    return json_parseado
  
  end

end
