  require 'sinatra'
  require 'rubygems'
  require 'json'
  require_relative './model/GestorCalendario'
  require_relative './model/web_response'




  #-------------------------------------
  # CREA UN CALENDARIO
  #-------------------------------------
  # LISTO
  #   {
  #    "nombre":"calendario1" 
  #   } 
  #  status=201
  #  status=400 (si el nombres esta duplicado o nombre vacio)
  post '/calendarios' do
    gestor = GestorCalendario.new()
    respuesta = gestor.crearCalendario(request.body.read)  
    status respuesta.getEstado()

    response.body = respuesta.getRespuesta()
  end

  #-------------------------------------
  # BORRA UN CALENDARIO
  #------------------------------------- 
  #
  # LISTO
  #DELETE /calendarios/calendario1
  #status=200
  #status=404 (no encontrado)

  delete '/calendarios/:nombre' do
    gestor = GestorCalendario.new()
    respuesta = gestor.borrarCalendario(params['nombre'])

    status respuesta.getEstado()
    response.body = respuesta.getRespuesta()
  end

  #-------------------------------------
  # DEVUELVE TODOS LOS CALENDARIOS
  #------------------------------------- 
  #
  # FALTA
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
    content_type :json
    
    gestor = GestorCalendario.new()
    calendarios = gestor.listarTodosLosCalendarios()
    
    response.body = calendarios
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
  get '/calendarios/:nombre' do
    content_type :json
    gestor = GestorCalendario.new()
    respuesta = gestor.obtenerCalendario(params['nombre'])

    status respuesta.getEstado()
    response.body = respuesta.getRespuesta()
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
    gestor = GestorCalendario.new()
    respuesta = gestor.crearEvento(request.body.read)  
    status respuesta.getEstado()

    response.body = respuesta.getRespuesta()
  end
    
  #-------------------------------------
  # MODIFICA UN EVENTO DADO UN CALENDARIO
  #------------------------------------- 
  # 
  #{
  #  "calendario":"untref", # no puede cambiar
  #  "id":"id_evento":, # no cambia
  #  "inicio": "2017-03-31T18:00:00-03:00",
  #  "fin": "2017-03-31T22:00:00-03:00"
  #}
  put '/eventos' do
    gestor = GestorCalendario.new()
    respuesta = gestor.modificarEvento(request.body.read)

    status respuesta.getEstado()

    response.body = respuesta.getRespuesta()
  end
  
  #-------------------------------------
  # BORRA UN EVENTO POR ID
  #------------------------------------- 
  # 
  delete '/eventos/:id' do
    gestor = GestorCalendario.new()
    respuesta = gestor.borrarEvento(params['id'])

    status respuesta.getEstado()

    response.body = respuesta.getRespuesta()
  end

  set(:query) {  |value| condition { request.query_string == "" } }
  #-------------------------------------
  # DEVUELVE TODOS LOS EVENTOS
  #-------------------------------------
  #
  get '/eventos', :query => true do

    content_type :json

    gestor = GestorCalendario.new()
    response.body = gestor.listarTodosLosEventos()

  end


  #-------------------------------------
  # DEVUELVE LOS EVENTOS DADO EL NOMBRE DE CALENDARIO
  #-------------------------------------
  #
  get '/eventos?:calendario?' do

    gestor = GestorCalendario.new()
    respuesta = gestor.listarEventosPorCalendario(params['calendario'])

    content_type respuesta.getContentType()
    status respuesta.getEstado()

    response.body = respuesta.getRespuesta()
  end

  

  
  

    
  #-------------------------------------
  # DEVUELVE EVENTO POR ID
  #------------------------------------- 
  #
  get '/eventos/:id' do
    content_type :json
    
    gestor = GestorCalendario.new()
    evento = gestor.obtenerEventoPorId(params['id'])
    
    response.body = evento
  end
