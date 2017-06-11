  require 'sinatra'
  require 'rubygems'
  require 'json'  #Libreria para parseo de JSON
  require_relative './model/GestorCalendario'
  require_relative './model/web_response'
  
  #Testear json posteado -> curl -H "Content-Type: application/json" -X POST -d '[{"nombre": "calendario1"},{"nombre": "calendario2"}]'  http://localhost:4567/calendarios
  #Obtener parametros post ->     numero_obtenido = "#{params['x']}"
 
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
    gestor.borrarCalendario(params['nombre'])
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
  # DEVUELVE LOS EVENTOS DADO EL NOMBRE DE CALENDARIO
  #------------------------------------- 
  # 
  get '/eventos' do    
    content_type :json
    gestor = GestorCalendario.new()
    gestor.listarEventosPorCalendario(params[:calendario]) 
  end
  
  #-------------------------------------
  # DEVUELVE LOS EVENTOS
  #------------------------------------- 
  # 
  get '/eventos' do   
  
    convertidor = ConvertidorObjetoJson.new()
  
    evento1 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) 
    
     evento2 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('diario',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z"))) 
    
     evento3 = Evento.new(Calendario.new("Calendario1"),
    "testEvento",
    "fiesta",
    DateTime.strptime("2017-03-31T18:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    DateTime.strptime("2017-03-31T22:00:00-03:00","%Y-%m-%dT%H:%M:%S%z"),
    Recurrencia.new('semanal',DateTime.strptime("2017-03-31T18:00:00-03:00", "%Y-%m-%dT%H:%M:%S%z")))
    
    array_eventos = [evento1,evento2,evento3]
    
    convertidor.convertir_eventos(array_eventos);
    
  
  end

  
  #-------------------------------------
  # DEVUELVE EVENTO POR ID
  #------------------------------------- 
  # 
  
  get '/eventos/id' do
  
  end
