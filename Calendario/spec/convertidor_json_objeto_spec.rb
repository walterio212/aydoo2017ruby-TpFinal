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
  
  #Test convertir_evento
  
  it 'Test metodo convertir_evento: El convertidor al recibir algo vacio deberia devolver nil' do
    expect(convertidor.convertir_evento("")).to eq nil
  end
  
  it 'Test metodo convertir_evento: El convertidor al recibir nil devolver nil' do
    expect(convertidor.convertir_evento(nil)).to eq nil
  end
  
  
  it 'Test metodo convertir_evento: 
  El convertidor al recibir 
  [
    {
        "calendario" : calendario1,
        "id" : eventoTest,
        "nombre" : fiesta,
        "inicio" : ,
        "fin" : ,
        "recurrencia" : {
            "frecuencia" : semanal,
            "fin" : 2017-06-28
        }
    }
    
  ] 
  deberia devolver un array de 1 posicion' do
    expect(convertidor.convertir_evento(
    '[{
        "calendario" : "calendario1",
        "id" : "eventoTest",
        "nombre" : "fiesta",
        "inicio" : "",
        "fin" : "",
        "recurrencia" : {
            "frecuencia" : "semanal",
            "fin" : "2017-06-28"
        }
    }]').size).to eq 1
  
  end
  
  it 'Test metodo convertir_evento: 
  El convertidor al recibir 
  [
    {
        "calendario" : calendario1,
        "id" : eventoTest,
        "nombre" : fiesta,
        "inicio" : ,
        "fin" : ,
        "recurrencia" : {
            "frecuencia" : semanal,
            "fin" : 2017-06-28
        }
    },
    {
        "calendario" : calendario2,
        "id" : eventoTest2,
        "nombre" : fiesta2,
        "inicio" : ,
        "fin" : ,
        "recurrencia" : {
            "frecuencia" : semanal,
            "fin" : 2017-06-28
        }
    },
    {
        "calendario" : calendario3,
        "id" : eventoTest3,
        "nombre" : fiesta3,
        "inicio" : ,
        "fin" : ,
        "recurrencia" : {
            "frecuencia" : semanal,
            "fin" : 2017-06-28
        }
    }
    
  ] 
  deberia devolver un array de 3 posiciones' do
    expect(convertidor.convertir_evento('[{
        "calendario" : "calendario1",
        "id" : "eventoTest",
        "nombre" : "fiesta",
        "inicio" : "",
        "fin" : "",
        "recurrencia" : {
            "frecuencia" : "semanal",
            "fin" : "2017-06-28"
        }
      },
      {
          "calendario" : "calendario2",
          "id" : "eventoTest2",
          "nombre" : "fiesta2",
          "inicio" : "",
          "fin" : "",
          "recurrencia" : {
              "frecuencia" : "semanal",
              "fin" : "2017-06-28"
          }
      },
      {
          "calendario" : "calendario3",
          "id" : "eventoTest3",
          "nombre" : "fiesta3",
          "inicio" : "",
          "fin" : "",
          "recurrencia" : {
              "frecuencia" : "semanal",
              "fin" : "2017-06-28"
          }
      }
    ]').size).to eq 3
  
  end
  
end
