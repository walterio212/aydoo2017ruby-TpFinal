require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/validador_calendario'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'


describe 'ValidadorCalendario' do 
  it 'crearCalendario nombre existente error' do
    persistorDouble = double('Persistor', :existe_calendario? => true)
    calendario = Calendario.new("calendario 1")
    validador = ValidadorCalendario.new(persistorDouble)

    expect{ validador.validar_crear_calendario(calendario) }.
      to raise_error(CalendarioNombreExistenteError)
  end
end

describe 'ValidadorCalendario' do 
  it 'crearCalendario nombre vacio error' do
    persistorDouble = double('Persistor', :existe_calendario? => false)
    calendario = Calendario.new("")
    validador = ValidadorCalendario.new(persistorDouble)

    expect{ validador.validar_crear_calendario(calendario) }.
      to raise_error(CalendarioSinNombreError)
  end
end