require 'rspec' 
require_relative '../model/calendario'

describe 'calendario' do

  let(:calendario) { Calendario.new("calendario1") }  
   
  it 'to_json devuelve el json del calendario' do

    result = JSON.generate(calendario.to_json)

    expect(result).to eq '{"nombre":"calendario1"}'
  end

end
