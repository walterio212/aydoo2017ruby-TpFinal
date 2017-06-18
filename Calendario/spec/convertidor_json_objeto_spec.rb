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

  it 'convertir actualizador con recurrencia crea la recurrencia en el objeto actualizador' do

    respuesta = convertidor.convertir_actualizador('{
        "id" : "eventoTest",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00",
        "recurrencia" : {
            "frecuencia" : "anual",
            "fin" : "2017-03-31T18:00:00-03:00"
        }
    }')

    expect(respuesta.getId()).to eq "eventoTest"
    expect(respuesta.getInicio().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getFin().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getRecurrencia().getFrecuencia()).to eq "anual"
    expect(respuesta.getRecurrencia().getFin().to_s).to eq "2017-03-31"
  end

  it 'convertir actualizador sin recurrencia crea el objeto actualizador con recurrencia nil' do

    respuesta = convertidor.convertir_actualizador('{
        "id" : "eventoTest",
        "inicio" : "2017-03-31T18:00:00-03:00",
        "fin" : "2017-03-31T18:00:00-03:00"     
    }')

    expect(respuesta.getId()).to eq "eventoTest"
    expect(respuesta.getInicio().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getFin().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getRecurrencia()).to eq nil
  end

  it 'convertir actualizador sin inicio crea el objeto actualizador con inicio nil' do

    respuesta = convertidor.convertir_actualizador('{
        "id" : "eventoTest",
        "fin" : "2017-03-31T18:00:00-03:00"     
    }')

    expect(respuesta.getId()).to eq "eventoTest"
    expect(respuesta.getInicio()).to eq nil
    expect(respuesta.getFin().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getRecurrencia()).to eq nil
  end

  it 'convertir actualizador sin inicio crea el objeto actualizador con inicio nil' do

    respuesta = convertidor.convertir_actualizador('{
        "id" : "eventoTest",
        "inicio" : "2017-03-31T18:00:00-03:00"     
    }')

    expect(respuesta.getId()).to eq "eventoTest"
    expect(respuesta.getInicio().to_s).to eq "2017-03-31T18:00:00-03:00"
    expect(respuesta.getFin()).to eq nil
    expect(respuesta.getRecurrencia()).to eq nil
  end

  it 'convertir actualizador json nil devuelve nil' do

    respuesta = convertidor.convertir_actualizador(nil)

    expect(respuesta).to eq nil
  end

  it 'convertir actualizador json vacio devuelve nil' do

    respuesta = convertidor.convertir_actualizador("")

    expect(respuesta).to eq nil
  end
end
