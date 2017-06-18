require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/validador_evento'
require_relative '../model/evento_id_ya_existente_error'
require_relative '../model/../model/evento_ya_existente_en_calendario_error'
require_relative '../model/../model/../model/calendario_sin_nombre_error'
require_relative '../model/../model/../model/../model/evento_calendario_no_existente_error'
require_relative '../model/../model/../model/../model/../model/evento_fechas_incoherentes_error'
require_relative '../model/../model/../model/../model/../model/evento_duracion_maxima_invalida_error'
require_relative '../model/../model/../model/../model/../model/evento_superposicion_de_eventos_error'
require_relative '../model/../model/../model/../model/../model/../model/evento_ya_existente_error'
require_relative '../model/../model/../model/../model/../model/../model/../model/evento_inexistente_error'


describe 'ValidadorEvento' do

  it 'crearEventoConUnIdExistenteDaError' do
    persistorDouble = double('Persistor', :listar_todos_los_eventos => [Evento.new("calendario1","fiesta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])
    crearEvento = Evento.new("calendario2","fiesta","fiesaLocaDeDisfraces",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_id_evento_ya_existente(crearEvento.getId) }.
        to raise_error(EventoIdYaExistenteError)
  end

  it 'crearEventoConIdExistenteDaError' do

    persistorDouble = double('Persistor', :listar_todos_los_eventos => [Evento.new("calendario1","fiesta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
    Evento.new("calendario1","fiestaSecreta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
    Evento.new("calendario1","fiestaNoTanSecreta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    crearEvento = Evento.new("calendario2","fiestaSecreta","fiesaLocaDeDisfraces",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_id_evento_ya_existente(crearEvento.getId) }.
        to raise_error(EventoIdYaExistenteError)

  end

  it 'crearEventoIdInexistenteDeberiaDevolverTrue' do

    persistorDouble = double('Persistor', :listar_todos_los_eventos => [Evento.new("calendario1","fiesta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])
    crearEvento = Evento.new("calendario2","fiestaNoTanConocida","fiesaLocaDeDisfraces",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect(validador.validar_id_evento_ya_existente(crearEvento.getId)).to eq true

  end

  it 'duplicarNombreEventoEnCalendarioDeberiaDarErrror' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiesaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                        Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                        Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    crearEvento = Evento.new("calendario1","fiestaSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_nombre_evento_ya_existente_en_calendario("Calendario1",crearEvento.getNombre) }.
        to raise_error(EventoYaExistenteEnCalendarioError)

  end

  it 'duplicarNombreEventoEnCalendarioDeberiaDarErrror' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    crearEvento = Evento.new("calendario1","fiestaSecreta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_nombre_evento_ya_existente_en_calendario("Calendario1",crearEvento.getNombre) }.
        to raise_error(EventoYaExistenteEnCalendarioError)

  end


  it 'darNombreInexistenteDeEventoEnCalendarioDeberiaDarTrue' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    crearEvento = Evento.new("calendario1","fiestaSecreta","fiestaLocaInexistente",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect(validador.validar_nombre_evento_ya_existente_en_calendario("calendario1",crearEvento.getNombre)).to eq true

  end



  it 'darNombreCalendarioNilAlCrearEventoDeberiaDevolverError' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_nombre_calendario_no_vacio(nil) }.
        to raise_error(CalendarioSinNombreError)

  end


  it 'darNombreCalendarioVacioAlCrearEventoDeberiaDevolverError' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_nombre_calendario_no_vacio("") }.
        to raise_error(CalendarioSinNombreError)

  end


  it 'darNombreCalendarioNOVacioAlCrearEventoDeberiaDevolverTrue' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [Evento.new("calendario1","fiesta","fiestaLoca1",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaSecreta","fiesaLoca2",Date.new(),Date.new(),Recurrencia.new("anual",Date.new())),
                                                                             Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])

    validador = ValidadorEvento.new(persistorDouble)
    expect(validador.validar_nombre_calendario_no_vacio("CalendarioFantastico")).to eq true

  end

  it 'darNombreCalendarioExistenteAlCrearEventoDeberiaDevolverTrue' do

    persistorDouble = double('Persistor', :existe_calendario? => true)

    validador = ValidadorEvento.new(persistorDouble)
    expect(validador.validar_calendario_existente("Calendario1")).to eq true

  end

  it 'darNombreCalendarioInexisteAlCrearEventoDeberiaDevolverError' do

    persistorDouble = double('Persistor', :existe_calendario? => false)

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_calendario_existente("") }.
        to raise_error(EventoCalendarioNoExistenteError)

  end

  it 'validarFechaFinPosteriorFechaInicioDeberiaDevolverTrueSiSeCumpleLaCondicion' do

    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now()
    fechaFin = fechaFin >> 1

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect(validador.validar_fecha_fin_posterior_fecha_inicio(evento)).to eq true

  end


  it 'validarFechaFinPosteriorFechaInicioDeberiaDevolverErrorSiNOSeCumpleLaCondicion' do

    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now()
    fechaInicio = fechaInicio >> 1

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect{ validador.validar_fecha_fin_posterior_fecha_inicio(evento) }.
        to raise_error(EventoFechasIncoherentesError)

  end

  it 'validarDuracionEventoPermitidoSiDura5DiasNoCumpleLaCondicionDevuelveError' do

    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now() + 5 #5 dia

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect{ validador.validar_duracion_evento_permitida(evento) }.
        to raise_error(EventoDuracionMaximaInvalidaError)
  end


  it 'validarDuracionEventoPermitidoSiDuraMenosDe3DiasCumpleLaCondicionDevuelveTrue' do
    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now() + 2#dias

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect( validador.validar_duracion_evento_permitida(evento) ).to eq true
  end

  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaDevovlerErrorAlSuperponerseConEvento1y2' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                        EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                        EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2017-08-30T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2017-06-17T15:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoAnual.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("anual",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_no_superposicion_de_eventos(evento) }.
        to raise_error(EventoSuperposicionDeEventosError)

  end


  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaCrearEventoAlNoHaberSuperposicion' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2017-08-30T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2017-06-17T14:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2017-06-17T17:45:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoAnual.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("anual",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)
    expect( validador.validar_no_superposicion_de_eventos(evento) ).to eq true
  end


  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaCrearEventoAlNoHaberSuperposicion' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2017-08-30T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2017-06-17T14:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2017-06-17T17:45:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoDiario.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("diaria",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)
    expect( validador.validar_no_superposicion_de_eventos(evento) ).to eq true
  end


  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaCrearEventoAlNoHaberSuperposicion' do

    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2017-08-30T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2017-07-17T08:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2017-07-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoDiario.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("diaria",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)
    expect( validador.validar_no_superposicion_de_eventos(evento) ).to eq true
  end



  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaDevovlerErrorAlSuperponerseConEventoSemanal' do


    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2017-08-30T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2017-06-24T08:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2017-06-24T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoDiario.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("diaria",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)

    expect{ validador.validar_no_superposicion_de_eventos(evento) }.
        to raise_error(EventoSuperposicionDeEventosError)

  end


  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaDevovlerErrorAlSuperponerseConEventoAnual' do


    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2019-08-30T23:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2018-06-17T10:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2018-06-17T15:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoDiario.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("diaria",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)

    expect{ validador.validar_no_superposicion_de_eventos(evento) }.
        to raise_error(EventoSuperposicionDeEventosError)

  end


  it 'validarNoSuperposicionDeEventosAlCrearEventoDeberiaDevovlerTrueAlSuperponerseConEventoAnualPeroConHorarioDiferente' do


    persistorDouble = double('Persistor', :listar_eventos_por_calendario => [EventoDiario.new("calendario1","fiestaddd","fiestaLocaf1",DateTime.strptime("2017-06-17T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T20:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("diario",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoSemanal.new("calendario1","fiestaSecreta","fiesaLocac2",DateTime.strptime("2017-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T09:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("semanal",DateTime.strptime("2017-06-30T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))),
                                                                             EventoAnual.new("calendario1","fiestaNoTanSecreta","fiestaxcLoca3",DateTime.strptime("2017-06-17T10:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-17T12:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),Recurrencia.new("mensual",DateTime.strptime("2019-08-30T23:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))])

    fechaInicio = DateTime.strptime("2018-06-17T19:30:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin = DateTime.strptime("2018-06-17T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")

    evento = EventoDiario.new("calendario1","fidssdaesta2017","fiesadsataLoca4",fechaInicio,fechaFin,Recurrencia.new("diaria",DateTime.strptime("2018-06-17T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")))

    validador = ValidadorEvento.new(persistorDouble)
    
    expect( validador.validar_no_superposicion_de_eventos(evento) ).to eq true

  end

end
