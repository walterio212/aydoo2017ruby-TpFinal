require 'rspec' 
require_relative '../model/recurrencia'

describe 'recurrencia' do

  let(:recurrencia) { Recurrencia.new("semanal",DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z")) }  
   
  
  it 'to_json devuelve el json de la recurrencia' do

    result = JSON.generate(recurrencia.to_json)

    expect(result).to eq '{"frecuencia":"semanal","fin":"2017-03-31T18:00:00-03:00"}'
  end

end
