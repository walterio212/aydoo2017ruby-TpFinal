require 'rspec' 
require 'date'
require 'json'
require_relative '../model/calendario_eventos'
require_relative '../model/evento'
require_relative '../model/evento_diario'
require_relative '../model/calendario'
require_relative '../model/recurrencia'

describe 'CalendarioEventos' do 
  it 'to_json de Calendario Eventos devuelve el json de CalendarioEventos invocando a to_json de calendario y de eventos' do

    recurrencia = Recurrencia.new("semanal", DateTime.new(2001, 4, 20))
    eventodiario1 = EventoDiario.new("calendario1","ev1","evento1",DateTime.new(2001, 3, 29),DateTime.new(2001, 3, 30),recurrencia)
    eventodiario2 = EventoDiario.new("calendario1","ev2","evento2",DateTime.new(2001, 3, 29),DateTime.new(2001, 3, 30),recurrencia)
    calendario1 = Calendario.new("calendario1")

    calEventos = CalendarioEventos.new(calendario1, [eventodiario1, eventodiario2])

    json = JSON.dump(calEventos.to_json())

    expect(json).to eq "{\"calendario\":{\"nombre\":\"calendario1\"},\"eventos\":[{\"calendario\":\"calendario1\",\"id\":\"ev1\",\"nombre\":\"evento1\",\"inicio\":\"2001-03-29T00:00:00+00:00\",\"fin\":\"2001-03-30T00:00:00+00:00\",\"recurrencia\":{\"frecuencia\":\"semanal\",\"fin\":\"2001-04-20T00:00:00+00:00\"}},{\"calendario\":\"calendario1\",\"id\":\"ev2\",\"nombre\":\"evento2\",\"inicio\":\"2001-03-29T00:00:00+00:00\",\"fin\":\"2001-03-30T00:00:00+00:00\",\"recurrencia\":{\"frecuencia\":\"semanal\",\"fin\":\"2001-04-20T00:00:00+00:00\"}}]}"
  end
end