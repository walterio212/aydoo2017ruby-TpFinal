require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/GestorCalendario'

describe 'GestorCalendario' do
  it 'Borrar Calendario invoca al persistor a borrar calendario' do
    persistorDouble = double('Persistor', :borrar_calendario => "borrado") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto')
    validador = double("Validador")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")

    expect(persistorDouble).to receive(:borrar_calendario).with("calendario1")
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    gestor.borrarCalendario("calendario1")
  end

  it 'Obtener CAlendario invoca al persistor a obtener_calendario' do
    persistorDouble = double('Persistor', :obtener_calendario => "{ 'nombre' : 'calendario1' }") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto')
    validador = double("Validador")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")

    expect(persistorDouble).to receive(:obtener_calendario).with("calendario1")
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    calendario = gestor.obtenerCalendario("calendario1")

    expect(calendario).to eq "{ 'nombre' : 'calendario1' }"
  end

  it 'Crear calendario invoca al conversor y al persistor para crearlo' do
    calendario = Calendario.new("calendario1")
    
    validador = double("Validador", :validar_crear_calendario => "validado")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")
    persistorDouble = double('Persistor', :crear_calendario => "creado") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto', :convertir_calendario_no_array => calendario)

    expect(persistorDouble).to receive(:crear_calendario).with(calendario)
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    gestor.crearCalendario("calendario1")
  end
end