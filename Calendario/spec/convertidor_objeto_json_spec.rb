require 'rspec' 
require_relative '../model/convertidor_objeto_json'

describe 'ConvertidorObjetoJson' do

  let(:convertidor) { ConvertidorObjetoJson.new }  
  
  #TEST DE CONVERSION DE CALENDARIOS
   
  it 'Test metodo convertir_calendario: El convertidor al recibir nil devolver nil' do
    expect(convertidor.convertir_calendario(nil)).to eq nil
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con un calendario deberia devolver un array Json con ese calendario' do
  
    calendario = Calendario.new("calendario1")
  
    expect(convertidor.convertir_calendario(calendario)).to eq '{"nombre":"calendario1"}'
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con 2 calendarios deberia devolver un array Json con esos calendarios' do
        
    calendarios = [Calendario.new("calendario1"),Calendario.new("calendario2")]
    
    expect(convertidor.convertir_calendarios(calendarios)).to eq ['{"nombre":"calendario1"}','{"nombre":"calendario2"}']
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con 5 calendarios deberia devolver un array Json con esos calendarios' do
        
    calendarios = [Calendario.new("calendario1"),Calendario.new("calendario2"),Calendario.new("calendario3"),Calendario.new("calendario4"),Calendario.new("calendario5")]
    
    expect(convertidor.convertir_calendarios(calendarios).size).to eq 5
  end
  
  #TESTS DE CONVERSION DE EVENTOS
  
  
  it 'TestMetodoConvertirEventoNilEnviadoDeberiaDevolverNil' do
    expect(convertidor.convertir_evento(nil)).to eq nil
  end
  
  it 'TestMetodoConvertirEvento:AlRecibirUnEventoDeberiaDevolverSuJson' do
        
    evento = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z")))  

        expect(convertidor.convertir_evento(evento)).to eq  '{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}}'   
       
  end
  
   it 'TestMetodoConvertirEvento:AlRecibirUnEventoDeberiaDevolverSuJson' do
        
    evento1 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) 
    
     evento2 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('diario',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) 
    
     evento3 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z")))
    
    array_eventos = [evento1,evento2,evento3]    

        expect(convertidor.convertir_eventos(array_eventos)).to eq  ['{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}}','{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"diario","fin":"2017-03-31T18:00:00-03:00"}}','{"calendario":"Calendario1","id":"testEvento","nombre":"fiesta","inicio":"2017-03-31T18:00:00-03:00","fin":"2017-03-31T22:00:00-03:00","recurrencia":{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}}']   
       
  end
  
  
  
end
