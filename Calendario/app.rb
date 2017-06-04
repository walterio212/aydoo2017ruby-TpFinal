  require 'sinatra'
  require 'rubygems'
  require 'json'  #Libreria para parseo de JSON

  #Testear json posteado -> curl -H "Content-Type: application/json" -X POST -d '[{"nombre": "calendario1"},{"nombre": "calendario2"}]'  http://localhost:4567/calendarios
  #Obtener parametros post ->     numero_obtenido = "#{params['x']}"
 
  #-------------------------------------
  # CREA UN CALENDARIO
  #------------------------------------- 
  #   {
  #    "nombre":"calendario1" 
  #   } 
  #  status=201
  #  status=400 (si el nombres esta duplicado o nombre vacio)
  post '/calendarios' do
 
    
  end

  #-------------------------------------
  # BORRA UN CALENDARIO
  #------------------------------------- 
  # 
  #DELETE /calendarios/calendario1
  #status=200
  #status=404 (no encontrado)
  delete '/calendarios/' do
  
  end

  #-------------------------------------
  # DEVUELVE TODOS LOS CALENDARIOS
  #------------------------------------- 
  # 
  #[
  #  {
  #    "nombre":"calendario1"
  #  },
  #  {
  #   "nombre":"calendario2"
  #  }
  #]
  #status=200  
  get '/calendarios' do

  end

  #-------------------------------------
  # DEVUELVE UN CALENDARIO POR NOMBRE
  #------------------------------------- 
  # 
  #{
  #  "nombre":"calendario1"
  #}
  #status = 200
  #status = 404 (si no existe)
  get '/calendarios/nombreCalendario' do

  end
    
  #-------------------------------------
  # CREA UN EVENTO EN EL CALENDARIO ESPECFICADO
  #------------------------------------- 
  # 
  #  {
  #  "calendario":"untref",
  #  "id":"unico-global"
  #  "nombre":"aydoo",
  #  "inicio": "2017-03-31T18:00:00-03:00",
  #  "fin": "2017-03-31T22:00:00-03:00",
  #  "recurrencia": {
  #    "frecuencia": "semanal",
  #    "fin":"2017-06-28"
  #  }
  #}
  #status=201
  #status=400 (si hay un error de validación)
  post '/eventos' do

  end
    
  #-------------------------------------
  # MODIFICA UN EVENTO DADO UN CALENDARIO
  #------------------------------------- 
  # 
  #{
  #  "calendario":"untref", # no puede cambiar
  #  "nombre":"aydoo", # no cambia
  #  "inicio": "2017-03-31T18:00:00-03:00",
  #  "fin": "2017-03-31T22:00:00-03:00",
  #}
  put '/eventos' do
  
  end
  
  #-------------------------------------
  # BORRA UN EVENTO POR ID
  #------------------------------------- 
  # 
  delete '/eventos/id' do
  
  end
  
  #-------------------------------------
  # DEVUELVE LOS EVENTOS
  #------------------------------------- 
  # 
  get '/eventos' do
  
  end
  
  #-------------------------------------
  # DEVUELVE LOS EVENTOS DADO EL NOMBRE DE CALENDARIO
  #------------------------------------- 
  # 
  get '/eventos?calendario=calendario1' do
  
  end
  
  #-------------------------------------
  # DEVUELVE EVENTO POR ID
  #------------------------------------- 
  # 
  
  get '/eventos/id' do
  
  end
