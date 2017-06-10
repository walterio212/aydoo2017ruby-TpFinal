require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/Persistidor'
require_relative '../model/GeneralError'

describe 'Persistidor' do 

  it 'Creacion de Persistidor no crea nada si el directorio existe' do
    fileDouble = double('File', :directory? => true) 
    dirDouble = double('Dir')
    expect(dirDouble).not_to receive(:mkdir)
    persistidor = Persistidor.new(fileDouble, dirDouble)
  end

  it 'Creacion de Persistidor inicializa el directorio si no existe' do
    fileDouble = double('File', :directory? => false) 
    dirDouble = double('Dir')

    allow(dirDouble).to receive(:mkdir).with("almacenamientoCalendario") {"creado"}
    expect(dirDouble).to receive(:mkdir).with("almacenamientoCalendario")
    persistidor = Persistidor.new(fileDouble, dirDouble)
  end

  it 'Crear Calendario inexistente crea un nuevo archivo para el Calendario' do
    fileDouble = double('File', :directory? => true, :file? => false)
    dirDouble = double('Dir')
    archivoMock = double('archivo', :puts => true, :close => "archivo Cerrado")

    calendario = Calendario.new("calendario 1")

    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario 1.txt", "w") { archivoMock } 
    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario 1.txt") {"almacenamientoCalendario/calendario 1.txt"} 

    fileDouble.should_receive(:new).with("almacenamientoCalendario/calendario 1.txt", "w").exactly(1).times
    persistidor = Persistidor.new(fileDouble, dirDouble)

    res = persistidor.crearCalendario(calendario)
    expect(res).to eq "archivo Cerrado"
  end

  it 'Crear Calendario existente lanza GeneralError' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')

    calendario = Calendario.new("calendario 1")
    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario 1.txt") {"almacenamientoCalendario/calendario 1.txt"} 

    persistidor = Persistidor.new(fileDouble, dirDouble)

    expect{ persistidor.crearCalendario(calendario) }.
      to raise_error(GeneralError, "Ya existe un calendario con el nombre ingresado")
    
  end

  it 'Obtener Calendario inexistente lanza GeneralError' do
    fileDouble = double('File', :directory? => true, :file? => false)
    dirDouble = double('Dir')

    calendario = Calendario.new("calendario 1")
    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario.txt") {"almacenamientoCalendario/calendario.txt"} 

    persistidor = Persistidor.new(fileDouble, dirDouble)

    expect{ persistidor.obtenerCalendario("calendario") }.
      to raise_error(GeneralError, "No existe un calendario con el nombre ingresado: calendario")    
  end
end