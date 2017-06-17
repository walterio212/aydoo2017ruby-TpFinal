require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

describe 'EventoAnual Tests' do

  let(:evento) { EventoAnual.new("Calendario1",
                                  "testEvento",
                                  "calse aydoo",
                                  DateTime.strptime("2017-06-07T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  DateTime.strptime("2017-06-07T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                                  Recurrencia.new('anual',DateTime.strptime("2019-10-25T22:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) }

  it 'periodo_dentro_de_evento? 2020 Fuera de rango deberia devolver false ' do

    fechaInicio = DateTime.strptime("2020-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2020-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver true al anio siguiente' do
    fechaInicio = DateTime.strptime("2018-06-07T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2018-06-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? deberia devolver true en el fin de la recurrencia' do
    fechaInicio = DateTime.strptime("2019-06-07T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2019-06-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true
  end


  it 'periodo_dentro_de_evento? deberia devolver true en el fin de la recurrencia con horario solapado' do
    fechaInicio = DateTime.strptime("2019-06-07T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2019-06-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true
  end


  it 'periodo_dentro_de_evento? deberia devolver true en el fin de la recurrencia pero fuera del horario' do
    fechaInicio = DateTime.strptime("2019-06-07T13:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2019-06-07T16:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end


end
