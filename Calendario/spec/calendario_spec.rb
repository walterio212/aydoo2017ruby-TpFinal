require 'rspec' 
require_relative '../model/calendario'

describe 'calendario' do

  let(:calendario) { Calendario.new("calendario1") }  
   
  it 'to_json devuelve el json del calendario' do

    result = calendario.to_json

    expect("{\"nombre\":\"calendario1\"}").to eq result.to_s
  end

end