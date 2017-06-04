require 'json'

class Calendario

  def initialize(nombre) 
    @nombre = nombre
  end

  def getNombre()
    @nombre
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var| 
      hash[var.to_s[1..-1]] = self.instance_variable_get var
    end

    hash.to_json
  end
  
end
