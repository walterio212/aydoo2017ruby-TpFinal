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

  it 'periodo_dentro_de_evento? deberia ser false, fechas en mes anterior' do

    fechaInicio = DateTime.strptime("2017-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? el 7 del mes siguiente deberia ser true' do

    fechaInicio = DateTime.strptime("2017-07-07T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-07-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)


    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? el 7 dos meses despues pero no en el horario deberia ser false' do

    fechaInicio = DateTime.strptime("2017-08-07T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-08-07T15:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)


    expect(fecha_ocupada).to eq  false
  end


  it 'periodo_dentro_de_evento? el 7 dos meses despues y solapado deberia ser true' do

    fechaInicio = DateTime.strptime("2017-08-07T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-08-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)


    expect(fecha_ocupada).to eq  true
  end



  it 'periodo_dentro_de_evento? el dia final de la recurrencia deberia ser true' do

    fechaInicio = DateTime.strptime("2017-10-07T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-10-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)


    expect(fecha_ocupada).to eq  true
  end


  it 'periodo_dentro_de_evento? el mes siguiente al finalizar la recurrencia deberia ser false' do

    fechaInicio = DateTime.strptime("2017-11-07T08:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-11-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)


    expect(fecha_ocupada).to eq false
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(DateTime.strptime("2017-08-07T17:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),DateTime.strptime("2017-08-07T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"))

    expect(fecha_ocupada).to eq  true
  end

end
