TP Final de AyDOO - Calendario
==============================

Integrantes : 
  Walter Davalos
  Valentin Tourriles
  
V1.1.0

El modelo de la aplicación se construyo en base  a la clase Persistor y la clase GestorCalendario. 

GestorCalendario posee la lógica de llamadas a los métodos de validación y llamados de persistencia de datos. Es el eslabon principal de comunicación con la app.rb. El gestor realiza las llamadas a los validadores correspondientes y las llamadas al persistor.
 
Para manejo de comunicación hacia app.rb usamos el objeto WebResponse. En este almacenamos los datos suficientes para que en la app.rb solo se deba realizar la asignación a las properties de respuesta web y no contenga nada de lógica. El web response tiene los atributos contentType, Respuesta, y Estado (por ejemplo status 404)

El gestor realiza una llamada a un objeto validador en caso de ser necesario. 
El validador realiza las operaciones correspondiente s y en caso de lanzar error este se atrapa en gestorCalendario y se setea la respuesta correspondiente dependiendo del error en el webresponse. 

Los objetos ConvertidorJsonObjeto y ConvertidorObjetoJson nos permiten realizar la conversión de las entradas del usuario para trabajar con objetos y viceversa para devolver objetos en formato json al usuario o guardarlos al persistirlos.

Para la persistencia decidimos hacer lo siguiente:
	La creación de un nuevo calendario genera un archivo .txt con el nombre del calendario. Dentro de el en la primer línea se guarda el json correspondiente al objeto   calendario. 

Al crear un evento para un calendario especifico este llega al persistor se convierte a json y se guarda en el archivo correspondiente al calendario de ese evento en la línea siguiente. Cada nuevo evento que desee crearse se agregara en una nueva línea del archivo del calendario.

Al borrar un calendario se eliminara el archivo completo.

Al borrar un evento lo que se hace es recrearse el archivo pisando todos los eventos quitando aquel que se dicidio borrar.

Para manejo de eventos decidimos crear una clase para cada tipo distinto de Evento heredando de ésta teniendo asi: EventoSemanal, EventoMensual, EventoAnual, EventoDiario. Cada uno de estos eventos debe implementar los métodos de  fecha_Ocupada?(fecha) que indica si la fecha ingresada esta ocupada por el evento y el método periodo_dentro_de_evento(fechainicio, fechafin) que indica si el periodo ingresado se encuentra solapado con el evento actual.

Estos eventos son instanciados dependiendo de la recurrencia. L
a clase EventoBuilder posee un diccionario que dependiendo de la clave de la recurrencia instancia el tipo de evento correspondiente con los parámetros ingresados.
