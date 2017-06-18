require 'rspec' 
require 'date'
require_relative '../model/calendario'
require_relative '../model/persistor'
require_relative '../model/GeneralError'
require_relative '../model/evento_diario'
require_relative '../model/evento_semanal'
require_relative '../model/actualizador_evento'

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

  it 'obtener eventos por id busca y devuelve el evento por id' do 
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
    evento = persistidor.obtener_evento_por_id("ev1")

    expect(evento.getId()).to eq "ev1"
    expect(evento.getNombre()).to eq "evento1"
    expect(evento.getCalendario()).to eq "calendario1"
  end

  it 'obtener eventos por id con evento inexistente devuelve nil' do 
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
    evento = persistidor.obtener_evento_por_id("ev14")

    expect(evento).to eq nil
  end

  it 'obtener eventos por id sin ningun evento devuelve nil' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    
    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")
    persistidor = Persistor.new(fileDouble, dirDouble, nil, conversorJsonObjetoDouble)
    evento = persistidor.obtener_evento_por_id("ev14")

    expect(evento).to eq nil
  end

  it 'crear evento agrega una linea con el json del evento' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    dirDouble = double('Dir')
    archivo = StringIO.new()

    evento = EventoDiario.new("calendario1","ev2","evento2",nil,nil,nil)

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt", "a+")
      .and_yield(archivo)

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(conversorObjetoJsonDouble)
      .to receive(:convertir_calendario)
      .with(evento) { "{'nombre': 'evento2', 'calendario': 'calendario1'}" }

    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, nil)
    calendario = persistidor.crear_evento(evento)

    expect(archivo.string).to eq "{'nombre': 'evento2', 'calendario': 'calendario1'}\n" 
  end

  it 'crear evento agrega una linea con el json del evento con mock propio' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    dirDouble = double('Dir')
    archivo = ArchivoDouble.new()
    archivo.puts("{'nombre':'calendario1'}")

    evento = EventoDiario.new("calendario1","ev2","evento2",nil,nil,nil)

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt", "a+")
      .and_yield(archivo)

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(conversorObjetoJsonDouble)
      .to receive(:convertir_calendario)
      .with(evento) { "{'nombre': 'evento2', 'calendario': 'calendario1'}" }

    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, nil)
    calendario = persistidor.crear_evento(evento)

    expect(archivo.getLineas()[0]).to eq "{'nombre':'calendario1'}"
    expect(archivo.getLineas()[1]).to eq "{'nombre': 'evento2', 'calendario': 'calendario1'}"
  end

  it 'borrar evento busca el evento entre todos los archivos y recrea el archvio sin el evento' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n")

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    eventoDiarioCal1 = EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil)
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}") { eventoDiarioCal1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }


    calendario1 = Calendario.new("calendario1")
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") { calendario1 }

    archivoRecreado = ArchivoDouble.new() 
    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario1.txt", "w") { archivoRecreado }

    allow(conversorObjetoJsonDouble).to receive(:convertir_calendario).with(calendario1) { "{'nombre': 'calendario1'}" }

    expect(conversorObjetoJsonDouble).not_to receive(:convertir_evento)
    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")
    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, conversorJsonObjetoDouble)
    persistidor.borrar_evento("ev1")

    lineas = archivoRecreado.getLineas()

    expect(lineas.size()).to eq 1
    expect(lineas[0]).to eq "{'nombre': 'calendario1'}"
  end

  it 'borrar evento busca el evento entre todos los archivos y recrea el archvio sin ese evento' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n")

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}", "{'nombre': 'evento2', 'id': 'ev3', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    eventoDiarioCal1 = EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil)
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}") { eventoDiarioCal1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    eventoAnterior = EventoDiario.new("calendario1","ev3","evento2",nil,nil,nil)

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev3', 'calendario': 'calendario1'}") { eventoAnterior }

    calendario1 = Calendario.new("calendario1")
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") { calendario1 }

    archivoRecreado = ArchivoDouble.new() 
    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario1.txt", "w") { archivoRecreado }

    allow(conversorObjetoJsonDouble).to receive(:convertir_calendario).with(calendario1) { "{'nombre': 'calendario1'}" }

    expect(conversorObjetoJsonDouble).to receive(:convertir_evento).with(eventoAnterior) { "{'nombre': 'evento2', 'id': 'ev3', 'calendario': 'calendario1'}" }
    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")
    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, conversorJsonObjetoDouble)
    persistidor.borrar_evento("ev1")

    lineas = archivoRecreado.getLineas()

    expect(lineas.size()).to eq 2
    expect(lineas[0]).to eq "{'nombre': 'calendario1'}"
    expect(lineas[1]).to eq "{'nombre': 'evento2', 'id': 'ev3', 'calendario': 'calendario1'}"
  end

  it 'modificar evento busca el evento entre todos los archivos le cambia fecha fin y fecha inicio y recrea el archvio con el evento modificado' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n")

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    eventoDiarioCal1 = EventoDiario.new("calendario1","ev1","evento1",nil,nil,nil)
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}") { eventoDiarioCal1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    expect(conversorObjetoJsonDouble).to receive(:convertir_evento)
      .with(eventoDiarioCal1) {"{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-29', 'fin': '2001-03-31'"}

    calendario1 = Calendario.new("calendario1")
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") { calendario1 }

    archivoRecreado = ArchivoDouble.new() 
    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario1.txt", "w") { archivoRecreado }

    allow(conversorObjetoJsonDouble).to receive(:convertir_calendario).with(calendario1) { "{'nombre': 'calendario1'}" }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")

    actualizador = ActualizadorEvento.new("ev1", DateTime.new(2001, 3, 29), DateTime.new(2001, 3, 31))

    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, conversorJsonObjetoDouble)
    persistidor.modificar_evento(actualizador)

    lineas = archivoRecreado.getLineas()

    expect(lineas.size()).to eq 2
    expect(eventoDiarioCal1.getInicio()).to eq DateTime.new(2001, 3, 29)
    expect(eventoDiarioCal1.getFin()).to eq DateTime.new(2001, 3, 31)
    expect(lineas[0]).to eq "{'nombre': 'calendario1'}"
    expect(lineas[1]).to eq "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-29', 'fin': '2001-03-31'"
  end

  it 'modificar evento busca el evento entre todos los archivos solo cambia la fecha inicio cuando el fin viene nil y recrea el archvio con el evento modificado' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n")

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    eventoDiarioCal1 = EventoDiario.new("calendario1","ev1","evento1",DateTime.new(2001, 3, 29),DateTime.new(2001, 3, 31),nil)
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}") { eventoDiarioCal1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    expect(conversorObjetoJsonDouble).to receive(:convertir_evento)
      .with(eventoDiarioCal1) {"{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-30', 'fin': '2001-03-31'"}

    calendario1 = Calendario.new("calendario1")
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") { calendario1 }

    archivoRecreado = ArchivoDouble.new() 
    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario1.txt", "w") { archivoRecreado }

    allow(conversorObjetoJsonDouble).to receive(:convertir_calendario).with(calendario1) { "{'nombre': 'calendario1'}" }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")

    actualizador = ActualizadorEvento.new("ev1", DateTime.new(2001, 3, 30), nil)

    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, conversorJsonObjetoDouble)
    persistidor.modificar_evento(actualizador)

    lineas = archivoRecreado.getLineas()

    expect(lineas.size()).to eq 2
    expect(eventoDiarioCal1.getInicio()).to eq DateTime.new(2001, 3, 30)
    expect(eventoDiarioCal1.getFin()).to eq DateTime.new(2001, 3, 31)
    expect(lineas[0]).to eq "{'nombre': 'calendario1'}"
    expect(lineas[1]).to eq "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-30', 'fin': '2001-03-31'"
  end

  it 'modificar evento busca el evento entre todos los archivos solo cambia la fecha fin cuando el inicio viene nil y recrea el archvio con el evento modificado' do 
    fileDouble = double('File', :directory? => true, :file? => true)
    dirDouble = double('Dir')
    conversorJsonObjetoDouble = double('conversorJsonObjeto')
    conversorObjetoJsonDouble = double('conversorObjetoJson')
    archivo = StringIO.new("{'nombre': 'calendario1'}\n")

    allow(fileDouble)
      .to receive(:join)
      .with("almacenamientoCalendario", "calendario1.txt") {"almacenamientoCalendario/calendario1.txt"} 

    allow(fileDouble)
      .to receive(:open)
      .with("almacenamientoCalendario/calendario1.txt")
      .and_yield(archivo)

    lineasArchivoCalendario1 = ["{'nombre': 'calendario1'}", "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}"]

    lineasArchivoCalendario2 = ["{'nombre': 'calendario2'}","{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}"]

    allow(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt") {["almacenamientoCalendario/calendario1.txt","almacenamientoCalendario/calendario2.txt"]}

    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario1.txt") { lineasArchivoCalendario1 }
    allow(fileDouble).to receive(:readlines).with("almacenamientoCalendario/calendario2.txt") { lineasArchivoCalendario2 }

    eventoDiarioCal1 = EventoDiario.new("calendario1","ev1","evento1",DateTime.new(2001, 3, 29),DateTime.new(2001, 3, 31),nil)
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}") { eventoDiarioCal1 }

    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_evento_no_array)
      .with("{'nombre': 'evento2', 'id': 'ev2', 'calendario': 'calendario2'}") { EventoDiario.new("calendario2","ev2","evento2",nil,nil,nil) }

    expect(conversorObjetoJsonDouble).to receive(:convertir_evento)
      .with(eventoDiarioCal1) {"{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-29', 'fin': '2001-03-30'"}

    calendario1 = Calendario.new("calendario1")
    allow(conversorJsonObjetoDouble)
      .to receive(:convertir_calendario_no_array)
      .with("{'nombre': 'calendario1'}\n") { calendario1 }

    archivoRecreado = ArchivoDouble.new() 
    allow(fileDouble).to receive(:new).with("almacenamientoCalendario/calendario1.txt", "w") { archivoRecreado }

    allow(conversorObjetoJsonDouble).to receive(:convertir_calendario).with(calendario1) { "{'nombre': 'calendario1'}" }

    expect(dirDouble).to receive(:glob).with("almacenamientoCalendario/*.txt")

    actualizador = ActualizadorEvento.new("ev1", nil, DateTime.new(2001, 3, 30))

    persistidor = Persistor.new(fileDouble, dirDouble, conversorObjetoJsonDouble, conversorJsonObjetoDouble)
    persistidor.modificar_evento(actualizador)

    lineas = archivoRecreado.getLineas()

    expect(lineas.size()).to eq 2
    expect(eventoDiarioCal1.getInicio()).to eq DateTime.new(2001, 3, 29)
    expect(eventoDiarioCal1.getFin()).to eq DateTime.new(2001, 3, 30)
    expect(lineas[0]).to eq "{'nombre': 'calendario1'}"
    expect(lineas[1]).to eq "{'nombre': 'evento1', 'id': 'ev1', 'calendario': 'calendario1'}, 'inicio': '2001-03-29', 'fin': '2001-03-30'"
  end
end

class ArchivoDouble

  def initialize()
    @lineas = []
  end

  def puts(linea)
    @lineas << linea
  end

  def getLineas()
    @lineas
  end

  def close()
  end
end