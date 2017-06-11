require 'json'
require_relative '../model/calendario'
require_relative '../model/GeneralError'
require_relative '../model/convertidor_objeto_json'
require_relative '../model/convertidor_json_objeto'

class Persistor 

  def initialize(fileClass = File, dirClass = Dir, convertidorObjetoJson = ConvertidorObjetoJson.new(), convertidorJsonObjeto = ConvertidorJsonObjeto.new())
    @file = fileClass
    @dir = dirClass
    @convertidorObjetoJson = convertidorObjetoJson
    @convertidorJsonObjeto = convertidorJsonObjeto
    @almacenamientoCalendario = "almacenamientoCalendario"
    inicializar_directorio()
  end 

  def crear_calendario(calendario)
    nombreCalendario = calendario.getNombre()
    fullName = obtener_fullname(nombreCalendario)
    if(!existe_el_archivo?(fullName))      
      archivo = @file.new(fullName, "w")
      json = @convertidorObjetoJson.convertir_calendario(calendario)
      archivo.puts(json)
      archivo.close
    else 
      raise GeneralError.new("Ya existe un calendario con el nombre ingresado")
    end
  end

  def obtener_calendario(nombreCalendario)
    calendario = nil
    calendarioJson = nil
    lineaJson = nil
    fullName = obtener_fullname(nombreCalendario)

    if(existe_el_archivo?(fullName))
      
      archivo = @file.open(fullName, "r") do |f| 
        f.each_line do |linea|
          lineaJson = linea
          calendarioJson = JSON.parse(linea)
          calendario = Calendario.new(calendarioJson["nombre"])
        end
      end      
    else 
      raise GeneralError.new("No existe un calendario con el nombre ingresado: " + nombreCalendario)
    end

    lineaJson
  end

  def borrar_calendario(nombreCalendario)
    fullName = obtener_fullname(nombreCalendario)

    if(existe_el_archivo?(fullName))
      @file.delete(fullName)      
    else 
      raise GeneralError.new("No existe un calendario con el nombre ingresado: " + nombreCalendario)
    end
  end

  def listar_todos_los_calendarios()
    path = @almacenamientoCalendario + "/*.txt"
    result = []
    @dir.glob(path) do |archivoCalendario|
      @file.open(archivoCalendario) { |f| result << @convertidorJsonObjeto.convertir_calendario_no_array(f.readline) }
    end
    
    result
  end

  def existe_calendario?(nombreCalendario)
    fullName = obtener_fullname(nombreCalendario)
    existe_el_archivo?(fullName)
  end

  def crear_evento(evento)
    fullName = obtener_fullname(evento.getCalendario())
    archivo = @file.open(fullName, "a+") do |f|     
      json = @convertidorObjetoJson.convertir_calendario(evento)
      f.puts(json)
      f.close      
    end  
  end

  private 

  def inicializar_directorio()
      if(!existe_el_directorio?())
        @dir.mkdir(@almacenamientoCalendario)
      end
  end

  def existe_el_directorio?()
    @file.directory?(@almacenamientoCalendario)
  end

  def existe_el_archivo?(nombre)
    @file.file?(nombre)
  end

  def obtener_fullname(nombreCalendario)
    nombreArchivo = nombreCalendario + ".txt"
    @file.join(@almacenamientoCalendario, nombreArchivo)
  end
end