require 'json'

class Calendario

  def initialize(nombre) 
    @nombre = nombre
  end

  def getNombre()
    @nombre
  end

  def to_json
    {"nombre"=>@nombre}
  end
  
end
