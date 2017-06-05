require 'json'  #Libreria para parseo de JSON
require_relative 'calendario'
require_relative 'evento'
require_relative 'recurrencia'

class ConvertidorJsonObjeto

  def convertir_calendario(json)
    
    respuesta = nil;
    
    if json.nil? || json.empty? || ! es_json?(json)
      return respuesta
    end
  
    json = hacer_json_valido(json)
    
    respuesta = []
  
    json_parseado = JSON.parse(json);
    
    json_parseado.each { |calendario_json| respuesta << Calendario.new(calendario_json["nombre"]) }
    
    return respuesta
  
  end
  
  def convertir_evento(json)
    
    respuesta = nil;
    
    if json.nil? || json.empty? || ! es_json?(json)
      return respuesta
    end
    
    json = hacer_json_valido(json)
    
    respuesta = []
  
    json_parseado = JSON.parse(json);
    
    json_parseado.each { |evento_json|
      
      
      #TODO chequear errores como si existe el calendario etc
    
      #convierto la recurrencia en objeto
  
      recurrencia = crear_recurrencia(evento_json["recurrencia"])
      
      respuesta << Evento.new(evento_json["calendario"],evento_json["nombre"],evento_json["id"],evento_json["inicio"],evento_json["fin"],recurrencia) }
    
    return respuesta
  
  end
  
  private
  
  def es_json?(json)
    
    respuesta = false
    
    if (json.chars.first =='{' && json.chars.last=='}') || (json.chars.first =='[' && json.chars.last==']')
      respuesta = true
    end 
      
    return respuesta

  end
  
  #en caso de que el json no sea un array de objetos json, lo convierte para poder ser tratado de esa manera
  def hacer_json_valido(json)
    
    if (json.chars.first =='{' && json.chars.last=='}')
      json.insert(0,"[")
      json.append("]")
    end 
      
    return json

  end

  
  def crear_recurrencia(json)
    
    #chequear que la frecuencia sea una frecuencia valida
    
    Recurrencia.new(json["frecuencia"],DateTime.parse(json["fin"]).to_date)

  end

  
end
