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

  it 'Listar todos los eventos lee todos los archivos y lista sus eventos' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    
    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'calendario': 'calendario1'}") { EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil) }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")
    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    calendarios = persistidor.listar_todos_los_eventos()

    expect(calendarios.size()).to eq 2
    expect(calendarios[0].getNombre()).to eq "evento1"
    expect(calendarios[1].getNombre()).to eq "evento2"
  end

  it 'Listar todos los eventos lee todos los archivos sin eventos en ellos devuelve array vacio' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    
    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'calendario': 'calendario1'}") { EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil) }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")
    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    calendarios = persistidor.listar_todos_los_eventos()

    expect(calendarios.size()).to eq 0
  end

  it 'Listar todos los eventos por nombre calendario busca el archivo y lista sus eventos' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    
    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'calendario': 'calendario1'}"]

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'calendario': 'calendario1'}") { EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil) }

    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    calendarios = persistidor.listar_eventos_por_calendario('calendario1')

    expect(calendarios.size()).to eq 1
    expect(calendarios[0].getNombre()).to eq "evento1"
  end

  it 'Listar todos los eventos por nombre calendario sin eventos devuelve array vacio' do
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    
    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}"]

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'calendario': 'calendario1'}") { EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil) }

    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    calendarios = persistidor.listar_eventos_por_calendario('calendario1')

    expect(calendarios.size()).to eq 0
  end
end