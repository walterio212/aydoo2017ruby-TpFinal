require 'rspec' 
require_relative '../model/convertidor_json_objeto'

describe 'ConvertidorJsonObjeto' do

  let(:convertidor) { ConvertidorJsonObjeto.new }  
   
  #Test convertir_calendario
   
  it 'Test metodo convertir_calendario: El convertidor al recibir algo vacio deberia devolver nil' do
    expect(convertidor.convertir_calendario("")).to eq nil
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir nil devolver nil' do
    expect(convertidor.convertir_calendario(nil)).to eq nil
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir [{"nombre": "calendario1"}] deberia devolver un array de 1 posicion' do
    expect(convertidor.convertir_calendario('[{"nombre": "calendario1"}]').size).to eq 1
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir [{"nombre": "calendario1"}] deberia tener un array de objetos Calentario y calendario1 en su primer posicion' do
    expect(convertidor.convertir_calendario('[{"nombre": "calendario1"}]')[0].getNombre).to eq "calendario1"
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir [{"nombre": "calendario1"},{"nombre": "calendario2"},{"nombre": "calendario3"}] deberia devolver un array de 3 posiciones' do
    expect(convertidor.convertir_calendario('[{"nombre": "calendario1"},{"nombre": "calendario2"},{"nombre": "calendario3"}]').size).to eq 3
  end
  
  it 'Test metodo convertir_calendario: El convertidor al recibir [{"nombre": "calendario1"},{"nombre": "calendario2"},{"nombre": "calendario3"}] deberia devolver un array de 3 posiciones' do
    expect(convertidor.convertir_calendario_no_array('{"nombre": "calendario1"}').getNombre()).to eq "calendario1"
  end

  it 'Test metodo convertir_evento: 
  El convertidor al recibir este json deberia tener id->eventoTest' do
    expect(convertidor.convertir_evento_no_array(
    '{
        "calendario" : "calendario1",
        "id" : "eventoTest",
        "nombre" : "fiesta",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00",
        "recurrencia" : {
            "frecuencia" : "semanal",
            "fin" : "2017-03-31T18:00:00-03:00"
        }
    }').getId).to eq "eventoTest"
  
  end

  it 'Test metodo convertir_evento:
  El convertidor al recibir este json deberia tener id->fiesta' do
    expect(convertidor.convertir_evento_no_array(
        '{
        "calendario" : "calendario1",
        "id" : "eventoTest",
        "nombre" : "fiesta",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00",
        "recurrencia" : {
            "frecuencia" : "mensual",
            "fin" : "2017-03-31T18:00:00-03:00"
        }
    }').getNombre).to eq "fiesta"

  end

  it 'Test metodo convertir_evento:
  El convertidor al recibir este json deberia tener id->inicio' do
    expect(convertidor.convertir_evento_no_array(
        '{
        "calendario" : "calendario1",
        "id" : "eventoTest",
        "nombre" : "fiesta",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00",
        "recurrencia" : {
            "frecuencia" : "anual",
            "fin" : "2017-03-31T18:00:00-03:00"
        }
    }').getRecurrencia.getFrecuencia).to eq "anual"




  end

end
