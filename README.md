Recetario
=========

Se trata de una aplicación sencilla para gestionar una base de datos de ingredientes y recetas, y la edición de calendarios para generar la lista de la compra.

Información técnica
-------------------

* Funciona con Ruby 2.0.x y Rails 4
* Utiliza [Charisma, de Muhammad Usman](http://usman.it/themes/charisma/), que incluye el magnífico [FullCalendar de Ada Shaw](http://arshaw.com/fullcalendar/)
* La funcionalidad de exportación de calendario genera un enlace que envía la lista de ingredientes a Omnifocus (con un handler x-omnifocus).
* Se incluye un juego de recetas e ingredientes a modo de ejemplo.


Instalación en Heroku
---------------------

Una vez instalada y subida la aplicación a Heroku, hay que activar las variables para la autenticación mínima:

    heroku run rake db:setup  (o db:migrate si no queremos cargar los seeds)
    heroku config:add HTTP_AUTH_NAME=XXX
    heroku config:add HTTP_AUTH_PASSWORD=YYY

Pantallazos
-----------

Antes que los tests, prefiero ver los pantallazos de las cosas que instalo, así que aquí van algunas capturas:

![Edición de recetas](https://github.com/pantulis/recetario/blob/master/doc/screenshots/edicion_receta.png?raw=true "Edición de recetas")

![Edición de calendario](https://github.com/pantulis/recetario/blob/master/doc/screenshots/edicion_calendario.png?raw=true "Edición del calendario")

![Cuadro de mandos](https://github.com/pantulis/recetario/blob/master/doc/screenshots/panel_control.png?raw=true "¿Qué hay hoy para comer?")


TODO
----

* Añadir un sistema de autenticación de verdad
* Hacerlo multiusuario
* Enviar caracteres UTF-8 a la exportación de Omnifocus (parece un problema de Omnifocus URI Handler)

