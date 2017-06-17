require 'rspec'
require_relative '../model/calendario'
require_relative '../model/evento'
require_relative '../model/recurrencia'

describe 'EventoDiario Tests' do

  let(:evento) { EventoDiario.new("Calendario1",
                            "testEvento",
                            "calse aydoo",
                            DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                            DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
                            Recurrencia.new('diario',DateTime.strptime("2017-05-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) }

  it 'periodo_dentro_de_evento? deberia devolver true (19:00 esta entre 18 y 22 horas)' do

    fechaInicio = DateTime.strptime("2017-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? deberia devolver true' do

    fechaInicio = DateTime.strptime("2017-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2044-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true
  end

  it 'periodo_dentro_de_evento? Event a las 19 pero un dia antes del comienzo deberia devolver false' do

    fechaInicio = DateTime.strptime("2017-03-30T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-03-30T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end


  it 'periodo_dentro_de_evento? Event a las 19 pero un dia despues del final deberia ser false' do

    fechaInicio = DateTime.strptime("2017-06-01T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2044-06-01T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end


  it 'periodo_dentro_de_evento? deberia devolver false, evento fuera del anio' do
    fechaInicio = DateTime.strptime("2018-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2018-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end

  it 'periodo_dentro_de_evento? deberia devolver false' do

    fechaInicio = DateTime.strptime("2018-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2044-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false
  end


  it 'periodo_dentro_de_evento?Evento anterior al vento testeado deberia devolver false' do


    fechaInicio = DateTime.strptime("2014-03-31T19:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2015-03-31T21:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  false

  end

  it 'periodo_dentro_de_evento?Evento solapado deberia dar true' do


    fechaInicio = DateTime.strptime("2017-03-31T13:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fechaFin =    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z")
    fecha_ocupada =  evento.periodo_dentro_de_Evento?(fechaInicio,fechaFin)

    expect(fecha_ocupada).to eq  true

  end


end
