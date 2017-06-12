require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

describe 'EventoSemanal Tests' do

  let(:evento) { EventoSemanal.new("Calendario1",
                                  "testEvento",
                                  "calse aydoo",
                                  DateTime.strptime("2016-06-07T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  DateTime.strptime("2016-06-07T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  Recurrencia.new('semanal',DateTime.strptime("2017-06-28T22:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) }

  it 'periodo_dentro_de_evento? deberia devolver false (Inicio y fin 7-6-2016 18:00-Fin 28-6-2016 22:00)' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2016-06-14T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2044-06-14T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? deberia devolver false' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2016-06-14T13:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2016-06-14T16:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver false' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2016-06-14T13:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2016-06-14T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2016-06-14T13:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2016-06-14T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? deberia devolver false' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2018-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2044-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2018-01-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2044-05-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

end
