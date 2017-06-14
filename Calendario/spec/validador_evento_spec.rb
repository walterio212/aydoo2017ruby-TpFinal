require 'rspec' 
require_relative '../model/calendario'
require_relative '../model/validador_evento'
require_relative '../model/evento_id_ya_existente_error'

describe 'ValidadorEvento' do
  it 'crearEvento id existente error' do

    persistorDouble = double('Persistor', :listar_todos_los_eventos => [Evento.new("calendario1","fiesta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])
    crearEvento = Evento.new("calendario2","fiesta","fiesaLocaDeDisfraces",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect{ validador.validar_id_evento_ya_existente(crearEvento.getId) }.
        to raise_error(EventoIdYaExistenteError)

  end

  it 'crearEventoIdExitosoDeberiaDevolverTrue' do

    persistorDouble = double('Persistor', :listar_todos_los_eventos => [Evento.new("calendario1","fiesta","fiesaLoca",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))])
    crearEvento = Evento.new("calendario2","fiestaNoTanConocida","fiesaLocaDeDisfraces",Date.new(),Date.new(),Recurrencia.new("anual",Date.new()))

    validador = ValidadorEvento.new(persistorDouble)
    expect(validador.validar_id_evento_ya_existente(crearEvento.getId)).to eq true

  end

end
