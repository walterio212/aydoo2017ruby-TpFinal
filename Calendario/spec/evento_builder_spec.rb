require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

class EventoBuilderSpec

  describe 'evento_builder' do

    let(:builder) { EventoBuilder.new() }

    it 'Al crear una recurrencia semanal el eventoBuilder deberia devolver un evento semanal' do

      json  = '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}}'

      evento_json = JSON.parse(json);

      evento = builder.crear(evento_json)

      expect(evento.class).to eq EventoSemanal
    end



    it 'Al crear una recurrencia anual el eventoBuilder deberia devolver un evento anual' do

      json  = '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"anual","fin":"2017-03-31T18:00:00-03:00"}}'

      evento_json = JSON.parse(json);

      evento = builder.crear(evento_json)

      expect(evento.class).to eq EventoAnual
    end



    it 'Al crear una recurrencia diaria el eventoBuilder deberia devolver un evento diario' do

      json  = '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"diaria","fin":"2017-03-31T18:00:00-03:00"}}'

      evento_json = JSON.parse(json);

      evento = builder.crear(evento_json)

      expect(evento.class).to eq EventoDiario
    end

    it 'Al crear un evento sin recurrencia el builder devuelve un eventoNoRecurrente' do

      json  = '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00"}'

      evento_json = JSON.parse(json);

      evento = builder.crear(evento_json)

      expect(evento.class).to eq EventoNoRecurrente
      expect(evento.getRecurrencia().getFrecuencia()).to eq "norecurrente"
      expect(evento.getRecurrencia().getFin()).to eq nil
    end

  end
end