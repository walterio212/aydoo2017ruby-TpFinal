require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/GestorCalendario'
require_relative '../model/calendario_nombre_existente_error'
require_relative '../model/calendario_sin_nombre_error'
require_relative '../model/calendario_inexistente_error'

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
    validador = double("Validador", :validar_calendario_existente => "ok")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")

    expect(persistorDouble).to receive(:obtener_calendario).with("calendario1")
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    rta = gestor.obtenerCalendario("calendario1")

    expect(rta.getRespuesta()).to eq "{ 'nombre' : 'calendario1' }"
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

  it 'Crear calendario duplicado error' do
    calendario = Calendario.new("calendario1")
    
    validador = double("Validador")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")
    persistorDouble = double('Persistor', :crear_calendario => "creado") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto', :convertir_calendario_no_array => calendario)

    allow(validador).to receive(:validar_crear_calendario).and_raise(CalendarioNombreExistenteError)

    expect(persistorDouble).not_to receive(:crear_calendario).with(calendario)
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    response = gestor.crearCalendario("calendario1")

    expect(response.getEstado()).to eq 400
    expect(response.getRespuesta()).to eq "Ya existe un calendario con el nombre ingresado"
  end

  it 'Crear calendario sin nombre error' do
    calendario = Calendario.new("calendario1")
    
    validador = double("Validador")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")
    persistorDouble = double('Persistor', :crear_calendario => "creado") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto', :convertir_calendario_no_array => calendario)

    allow(validador).to receive(:validar_crear_calendario).and_raise(CalendarioSinNombreError)

    expect(persistorDouble).not_to receive(:crear_calendario).with(calendario)
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    response = gestor.crearCalendario("calendario1")

    expect(response.getEstado()).to eq 400
    expect(response.getRespuesta()).to eq "El calendario ingresado posee el nombre vacio"
  end

  it 'Obtener CAlendario inexistente error' do
    persistorDouble = double('Persistor', :obtener_calendario => "{ 'nombre' : 'calendario1' }") 
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto')
    validador = double("Validador")
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")

    allow(validador).to receive(:validar_calendario_existente).and_raise(CalendarioInexistenteError)

    expect(persistorDouble).not_to receive(:obtener_calendario).with("calendario1")
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    rta = gestor.obtenerCalendario("calendario1")

    expect(rta.getEstado()).to eq 404
    expect(rta.getRespuesta()).to eq "El nombre de calendario ingresado no existe"
  end

  it 'crear Evento llama al conversor y al persistor' do
    evento = Evento.new("Calendario1",
                        "testEvento",
                        "fiesta",
                        DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                        DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                        Recurrencia.new('semanal',
                                        DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z")))
    
    convertidorObjetoJsonDouble = double("convertidorObjetoJsonDouble")
    persistorDouble = double('Persistor', :crear_evento => "creado") 
    validador = double('VAlidador')
    convertidorJsonObjetoDouble = double('ConvertidorJsonObjeto', :convertir_evento_no_array => evento)

    expect(persistorDouble).to receive(:crear_evento).with(evento)
    gestor = GestorCalendario.new(persistorDouble, convertidorJsonObjetoDouble, convertidorObjetoJsonDouble, validador)
    gestor.crearEvento('{
        "calendario" : "calendario1",
        "id" : "testEvento",
        "nombre" : "fiesta",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00",
        "recurrencia" : {
            "frecuencia" : "semanal",
            "fin" : "2017-03-31T18:00:00-03:00"
        }
    }')
  end
end