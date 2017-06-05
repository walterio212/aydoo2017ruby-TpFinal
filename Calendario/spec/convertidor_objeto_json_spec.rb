require 'rspec' 
require_relative '../model/convertidor_objeto_json'

describe 'ConvertidorObjetoJson' do

  let(:convertidor) { ConvertidorObjetoJson.new }  
   
  it 'Test metodo convertir_calendario: El convertidor al recibir nil devolver nil' do
    expect(convertidor.convertir_calendario(nil)).to eq nil
  end
  
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array vacio deberia devolver nil' do
    expect(convertidor.convertir_calendario([])).to eq nil
  end
  
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con un calendario deberia devolver un array Json con ese calendario' do
    expect(convertidor.convertir_calendario([Calendario.new("calendario1")])).to eq '[{"nombre":"calendario1"}]'
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con 2 calendarios deberia devolver un array Json con esos calendarios' do
    expect(convertidor.convertir_calendario([Calendario.new("calendario1"),Calendario.new("calendario2")])).to eq '[{"nombre":"calendario1"},{"nombre":"calendario2"}]'
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir un array con 5 calendarios deberia devolver un array Json con esos calendarios' do
    expect(convertidor.convertir_calendario([Calendario.new("calendario1"),Calendario.new("calendario2"),Calendario.new("calendario3"),Calendario.new     ("calendario4"),Calendario.new("calendario5")])).to eq '[{"nombre":"calendario1"},{"nombre":"calendario2"},{"nombre":"calendario3"},{"nombre":"calendario4"},{"nombre":"calendario5"}]'
  end
  
end
