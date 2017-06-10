require 'json'
require_relative '../model/calendario'
require_relative '../model/GeneralError'
require_relative '../model/convertidor_objeto_json'

class Persistor 

  def initialize(fileClass, dirClass)
    @file = fileClass
    @dir = dirClass
    @almacenamientoCalendario = "almacenamientoCalendario"
    inicializarDirectorio()
  end 

  def crearCalendario(calendario)
    nombreCalendario = calendario.getNombre()
    fullName = obtenerFullName(nombreCalendario)
    if(!existeElArchivo?(fullName))      
      archivo = @file.new(fullName, "w")
      archivo.puts(calendario.to_json)
      archivo.close
    else 
      raise GeneralError.new("Ya existe un calendario con el nombre ingresado")
    end
  end

  def obtenerCalendario(nombreCalendario)
    calendario = nil
    calendarioJson = nil
    lineaJson = nil
    fullName = obtenerFullName(nombreCalendario)

    if(existeElArchivo?(fullName))
      
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

  def borrarCalendario(nombreCalendario)
    fullName = obtenerFullName(nombreCalendario)

    if(existeElArchivo?(fullName))
      @file.delete(fullName)      
    else 
      raise GeneralError.new("No existe un calendario con el nombre ingresado: " + nombreCalendario)
    end
  end

  def inicializarDirectorio()
      if(!existeElDirectorio?())
        @dir.mkdir(@almacenamientoCalendario)
      end
  end

  def existeElDirectorio?()
    @file.directory?(@almacenamientoCalendario)
  end

  def existeElArchivo?(nombre)
    @file.file?(nombre)
  end

  def obtenerFullName(nombreCalendario)
    nombreArchivo = nombreCalendario + ".txt"
    @file.join(@almacenamientoCalendario, nombreArchivo)
  end
end