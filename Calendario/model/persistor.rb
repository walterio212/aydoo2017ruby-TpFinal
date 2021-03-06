require 'json'
require_relative '../model/calendario'
require_relative '../model/calendario_eventos'
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
    nombreCalendario = calendario.getNombre().downcase
    calendario.setNombre(nombreCalendario.downcase)

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

  def obtener_calendario_eventos(nombreCalendario)
    calendario = obtener_calendario_por_nombre(nombreCalendario)
    eventos = listar_eventos_por_calendario(nombreCalendario)

    calendarioEventos = CalendarioEventos.new(calendario, eventos)

    calendarioEventos
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

  def listar_eventos_por_calendario(nombreCalendario)
    fullName = obtener_fullname(nombreCalendario)
    eventosArray = []

    line_num = 0
    listar_eventos_por_archivo_en_array(fullName, eventosArray)

    eventosArray
  end

  def obtener_evento_por_id(idEvento)
    eventos = listar_todos_los_eventos()

    eventoABuscar = eventos.find { |evento| evento.getId() == idEvento }

    eventoABuscar
  end

  def listar_todos_los_eventos()
    
    path = @almacenamientoCalendario + "/*.txt"
    eventosArray = []

    @dir.glob(path).each do |archivoCalendario|
      line_num = 0
      listar_eventos_por_archivo_en_array(archivoCalendario, eventosArray)
    end

    eventosArray
  end

  def borrar_evento(idEvento)
    evento = obtener_evento_por_id(idEvento)
    nombreCalendario = evento.getCalendario()

    eventosCalendario = listar_eventos_por_calendario(nombreCalendario)
    evento = eventosCalendario.find { |eventoCalendario| eventoCalendario.getId() == idEvento }

    eventosCalendario.delete(evento)

    recrear_archivo(nombreCalendario, eventosCalendario)
  end

  def modificar_evento(actualizadorEvento)

    idEvento = actualizadorEvento.getId()

    evento = obtener_evento_por_id(idEvento)
    nombreCalendario = evento.getCalendario()

    eventosCalendario = listar_eventos_por_calendario(evento.getCalendario())
    evento = eventosCalendario.find { |eventoCalendario| eventoCalendario.getId() == idEvento }

    if(!actualizadorEvento.getInicio().nil?)
      evento.setInicio(actualizadorEvento.getInicio())  
    end
    
    if(!actualizadorEvento.getFin().nil?)
      evento.setFin(actualizadorEvento.getFin())
    end
    
    if(!actualizadorEvento.getRecurrencia().nil?)
      evento.setRecurrencia(actualizadorEvento.getRecurrencia())
    end

    recrear_archivo(nombreCalendario, eventosCalendario)
  end

  def obtener_calendario_por_nombre(nombreCalendario)
    fullName = obtener_fullname(nombreCalendario)
    
    result = nil

    @file.open(fullName) { |f| result = @convertidorJsonObjeto.convertir_calendario_no_array(f.readline) }
    
    result
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
    nombreArchivo = nombreCalendario.downcase + ".txt"
    @file.join(@almacenamientoCalendario, nombreArchivo)
  end

  def obtener_calendario_sin_eventos(nombreCalendario)
    archivoCalendario = obtener_fullname(nombreCalendario)
    calendario = nil
    @file.open(archivoCalendario) { |f| calendario = @convertidorJsonObjeto.convertir_calendario_no_array(f.readline)}
    calendario
  end

  def recrear_archivo(nombreCalendario, eventosCalendario)
    calendario = obtener_calendario_sin_eventos(nombreCalendario)
    fullName = obtener_fullname(nombreCalendario)
    archivo = @file.new(fullName, "w")
    jsonCalendario = @convertidorObjetoJson.convertir_calendario(calendario)
    archivo.puts(jsonCalendario)
    eventosCalendario.each {|x| archivo.puts(@convertidorObjetoJson.convertir_evento(x))}
    archivo.close
  end

  def listar_eventos_por_archivo_en_array(fullName, eventosArray)
    line_num = 0
    @file.readlines(fullName).each do |line|
      if(line_num != 0)
        evt = @convertidorJsonObjeto.convertir_evento_no_array(line)
        eventosArray << evt
      end

      line_num += 1
    end
  end
end