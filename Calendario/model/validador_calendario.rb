require_relative '../model/persistor'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'

class ValidadorCalendario 

  def initialize(persistor = Persistor.new())
    @persistor = persistor
  end

  def validar_crear_calendario(calendario)
    nombre = calendario.getNombre()
    validar_nombre_no_vacio(nombre)
    validar_existencia(nombre)
  end

  def validar_calendario_existente(nombre)
    if(!@persistor.existe_calendario?(nombre.downcase))
      raise CalendarioInexistenteError.new()
    end
  end

  private

  def validar_nombre_no_vacio(nombre)
    if(nombre.to_s == "")
      raise CalendarioSinNombreError.new()
    end
  end

  def validar_existencia(nombre)
    if(@persistor.existe_calendario?(nombre.downcase))
      raise CalendarioNombreExistenteError.new()
    end
  end
end
