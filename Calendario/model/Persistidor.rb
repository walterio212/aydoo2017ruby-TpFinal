require 'json'
require_relative '../model/calendario'
require_relative '../model/GeneralError'

class Persistidor 

  def initialize(fileClass, dirClass)
    @file = fileClass
    @dir = dirClass
  end 

  def crearCalendario(calendario)
    nombre = calendario.getNombre()
    nombreArchivo = nombre + ".txt"
    if(!existeElArchivo?(nombreArchivo))      
      archivo = @file.new(nombreArchivo, "w")
      archivo.puts(calendario.to_json)
      archivo.close
    else 
      raise GeneralError.new("Ya existe un calendario con el nombre ingresado")
    end
  end

  def obtenerCalendario(nombreCalendario)
    calendario = nil

    nombreArchivo = nombreCalendario + ".txt"

    if(existeElArchivo?(nombreArchivo))
      
      archivo = @file.open(nombreArchivo, "r") do |f| 
        f.each_line do |linea|
          calendarioJson = JSON.parse(linea)
          calendario = Calendario.new(calendarioJson["nombre"])
        end
      end      
    else 
      raise GeneralError.new("No existe un calendario con el nombre ingresado")
    end
  end

  def existeElDirectorio?(nombre)
    @file.directory?(nombre)
  end

  def existeElArchivo?(nombre)
    @file.file?(nombre)
  end
end