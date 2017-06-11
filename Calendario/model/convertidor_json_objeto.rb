require 'json'  #Libreria para parseo de JSON
require 'date'  #necesario para el parseo de fechas
require_relative 'calendario'
require_relative 'evento'
require_relative 'evento_builder'
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
  
  def convertir_calendario_no_array(json)
    
    respuesta = nil;
    
    if json.nil? 
      return respuesta
    end
   
    json_parseado = JSON.parse(json);
   
    return Calendario.new(json_parseado["nombre"])
  
  end

  def convertir_evento_no_array(json)

    respuesta = nil

    if json.nil? || json.empty? || ! es_json?(json)
      return respuesta
    end

    evento_json = JSON.parse(json);

    #Aca deberia crear el builder de eventos
    builder = EventoBuilder.new()
    respuesta = builder.crear(evento_json)

    return respuesta

  end
  
  def convertir_evento(json)
    
    respuesta = nil
    
    if json.nil? || json.empty? || ! es_json?(json)
      return respuesta
    end
    
    json = hacer_json_valido(json)
    
    respuesta = []
  
    json_parseado = JSON.parse(json);
    
    json_parseado.each { |evento_json|

    recurrencia = crear_recurrencia(evento_json["recurrencia"])

    inicio = json[0]["inicio"]
    fin = json[0]["fin"]

    fecha_inicio = DateTime.strptime(inicio,"%Y-%m-%dT%H:%M:%S%z")
    fecha_fin = DateTime.strptime(fin,"%Y-%m-%dT%H:%M:%S%z")
        
    respuesta << Evento.new(evento_json["calendario"],evento_json["nombre"],evento_json["id"],"Date.new()","Date.new()",recurrencia) }
    
    return respuesta
  
  end

  def obtenerPropiedadDeJson(nombrePropiedad, json)
    respuesta = nil;
    
    if json.nil? || json.empty? || ! es_json?(json)
      return respuesta
    end
    
    json_parseado = JSON.parse(json);
    respuesta = json_parseado["nombre"]
    
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
  
end
