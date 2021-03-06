class ConvertidorObjetoJson
  
  
  def convertir_calendarios(array_calendarios)

    if array_calendarios.nil? || array_calendarios.size == 0
      return nil
    end
    
      array_json = []
    
      array_calendarios.each_with_index {     
        |calendario,index|
        calendario_json = JSON.generate(calendario.to_json)
        array_json << calendario_json
      }    
    
    return array_json
  end
  
  
  def convertir_calendario(calendario)

    if calendario.nil?
      return nil
    end
    
    return JSON.generate(calendario.to_json)  
  end


  def convertir_evento(evento)

    if evento.nil? 
      return nil
    end
    
    return JSON.generate(evento.to_json)
  end
  
  
  def convertir_eventos(array_eventos)

    if array_eventos.nil? || array_eventos.size == 0
      return nil
    end
    
      array_json = []
    
      array_eventos.each_with_index {
        |evento,index|
        evento_json = JSON.generate(evento.to_json)
        array_json << evento_json
      }    
    
    return array_json 
  end

end
