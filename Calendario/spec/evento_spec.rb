require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

describe 'evento' do

  let(:evento) { Evento.new(Calendario.new("Calendario1"),
  "testEvento",
  "fiesta",
  DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
  DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
  Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) }  
   
  it 'to_json devuelve el json del evento' do

    result = JSON.generate(evento.to_json)

    expect(result).to eq  '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}}'
  end

end
