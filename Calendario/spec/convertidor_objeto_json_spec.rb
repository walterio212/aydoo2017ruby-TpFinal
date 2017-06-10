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
  
  
end
