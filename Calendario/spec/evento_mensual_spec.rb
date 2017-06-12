require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

describe 'EventoSemanal Tests' do

  let(:evento) { EventoMensual.new("Calendario1",
                                  "testEvento",
                                  "calse aydoo",
                                  DateTime.strptime("2017-06-07T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  DateTime.strptime("2017-06-07T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  Recurrencia.new('mensual',DateTime.strptime("2017-10-25T22:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) }

  it 'periodo_dentro_de_evento? deberia devolver false' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-06-07T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-06-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-07-07T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-07-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end


  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-08-06T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-08-06T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end


  #it 'periodo_dentro_de_evento? deberia devolver true' do
  #  fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-09-06T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-09-06T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))
#
#    expect(fecha_ocupada).to eq  true
#  end


end
