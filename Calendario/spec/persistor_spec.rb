require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/persistor'
require_relative '../model/GeneralError'
require_relative '../model/evento_diario'
require_relative '../model/evento_semanal'

describe 'Persistor' do 

  it 'Creacion de Persistor no crea nada si el directorio existe' do
    fileDouble = double('File', :directory? => true) 
    dirDouble = double('Dir')
    expect(dirDouble).not_to receive(:mkdir)
    persistidor = Persistor.new(fileDouble, dirDouble)
  end

  it 'Creacion de Persistor inicializa el directorio si no existe' do
    fileDouble = double('File', :directory? => false) 
    dirDouble = double('Dir')

    allow(dirDouble).to receive(:mkdir).with("almacenamientoCalendario") {"creado"}
    expect(dirDouble).to receive(:mkdir).with("almacenamientoCalendario")
    persistidor = Persistor.new(fileDouble, dirDouble)
  end

  it 'Crear Calendario inexistente crea un nuevo archivo para el Calendario' do
    fileDouble = double('File', :directory? => true, :file? => false)
    dirDouble = double('Dir')
    archivoMock = double('archivo', :puts => true, :close => "archivo Cerrado")

    calendario = Calendario.new("calendario 1")

    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario 1.txt", "w") { archivoMock } 
    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario 1.txt") {"almacenamientoCalendario/calendario 1.txt"} 

    fileDouble.should_receive(:new).with("almacenamientoCalendario/calendario 1.txt", "w").exactly(1).times
    persistidor = Persistor.new(fileDouble, dirDouble)

    res = persistidor.crear_calendario(calendario)
    expect(res).to eq "archivo Cerrado"
  end

  it 'Crear Calendario existente lanza GeneralError' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')

    calendario = Calendario.new("calendario 1")
    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario 1.txt") {"almacenamientoCalendario/calendario 1.txt"} 

    persistidor = Persistor.new(fileDouble, dirDouble)

    expect{ persistidor.crear_calendario(calendario) }.
      to raise_error(GeneralError, "Ya existe un calendario con el nombre ingresado")
    
  end

  it 'Borrar Calendario inexistente lanza GeneralError' do
    fileDouble = double('File', :directory? => true, :file? => false)
    dirDouble = double('Dir')

    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario.txt") {"almacenamientoCalendario/calendario.txt"} 

    persistidor = Persistor.new(fileDouble, dirDouble)

    expect{ persistidor.borrar_calendario("calendario") }.
      to raise_error(GeneralError, "No existe un calendario con el nombre ingresado: calendario")    
  end

  it 'Borrar Calendario existente borra el archivo' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')

    allow(fileDouble).to receive(:join).with("almacenamientoCalendario", "calendario.txt") {"almacenamientoCalendario/calendario.txt"} 
    allow(fileDouble).to receive(:delete).with("almacenamientoCalendario/calendario.txt") {"borrado"}
    expect(fileDouble).to receive(:delete).with("almacenamientoCalendario/calendario.txt")

    persistidor = Persistor.new(fileDouble, dirDouble)

    persistidor.borrar_calendario("calendario")
  end

  it 'Obtener calendario por nombre devuelve el objeto calendario' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    dirDouble = double('Dir')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n{'nombre': 'evento1', 'calendario': 'calendario1'}")

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") {Calendario.new("calendario1")}

    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    calendario = persistidor.obtener_calendario_por_nombre("calendario1")

    expect(calendario.getNombre()).to eq "calendario1"
  end

  it 'Existe calendario devuelve true si existe el archivo de calendario' do 
    fileDouble = double('File', :directory? => true, :file? => false)
    dirDouble = double('Dir')
    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble).to receive(:file?).with("almacenamientoCalendario/calendario1.txt") { true }

    persistidor = Persistor.new(fileDouble, dirDouble, nil, nil)
    existeCalendario = persistidor.existe_calendario?("calendario1")

    expect(existeCalendario).to eq true
  end

  it 'Existe calendario devuelve false si no existe el archivo de calendario' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble).to receive(:file?).with("almacenamientoCalendario/calendario1.txt") { false }

    persistidor = Persistor.new(fileDouble, dirDouble, nil, nil)
    existeCalendario = persistidor.existe_calendario?("calendario1")

    expect(existeCalendario).to eq false
  end
end