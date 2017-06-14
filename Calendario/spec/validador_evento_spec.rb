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

  it 'velidarFechaFinPosteriorFechaInicioDeberiaDevolverTrueSiSeCumpleLaCondicion' do

    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now()
    fechaFin = fechaFin >> 1

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect(validador.validar_fecha_fin_posterior_fecha_inicio(evento)).to eq true

  end


  it 'velidarFechaFinPosteriorFechaInicioDeberiaDevolverErrorSiNOSeCumpleLaCondicion' do

    persistorDouble = double('Persistor')

    validador = ValidadorEvento.new(persistorDouble)
    fechaInicio = DateTime.now()
    fechaFin = DateTime.now()
    fechaInicio = fechaInicio >> 1

    evento = Evento.new("calendario1","fiestaNoTanSecreta","fiestaLoca3",fechaInicio,fechaFin,Recurrencia.new("anual",Date.new()))

    expect{ validador.validar_fecha_fin_posterior_fecha_inicio(evento) }.
        to raise_error(EventoFechasIncoherentesError)

  end



end
