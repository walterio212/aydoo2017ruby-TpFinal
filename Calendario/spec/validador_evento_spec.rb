require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/validador_evento'
require_relative '../model/evento_id_ya_existente_error'
require_relative '../model/../model/evento_ya_existente_en_calendario_error'

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



end