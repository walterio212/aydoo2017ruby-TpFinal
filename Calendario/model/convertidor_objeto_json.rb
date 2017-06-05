class ConvertidorObjetoJson
  
  def convertir_calendario(array_calendarios)

    if array_calendarios.nil? || array_calendarios.size == 0
      return nil
    end
    
    array_json = "["
    
    array_calendarios.each_with_index {
      |calendario,index|
           
      calendario_json = calendario.to_json
      
      array_json << calendario_json      
      if(index<array_calendarios.size-1)
        array_json << ',' 
      end
    }    
    
    array_json << ']'
    
    return array_json
    
  end
  
end
