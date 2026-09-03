# language: es
Característica: Navegación y Vistas del Módulo Tus Espacios
  Como usuario de BuscoBien
  Quiero acceder a mis espacios y gestionar mis propiedades
  Para administrar mis publicaciones inmobiliarias

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en el módulo "Tus Espacios"

  Escenario: Vista de usuario invitado
    Dado que el usuario no ha iniciado sesión
    Cuando el usuario abre la pantalla "Tus Espacios"
    Entonces el sistema deberá mostrar el mensaje "No hay propiedades que mostrar"
    Y el sistema deberá mostrar un botón "Ingresa como promotor para publicar propiedades"
    Y el sistema deberá mostrar un botón "Ingresa como usuario para ver propiedades"
    Cuando el usuario presiona cualquiera de los botones
    Entonces el sistema deberá mostrar el diálogo de login

  Escenario: Vista de usuario normal autenticado
    Dado que el usuario ha iniciado sesión como usuario normal (no promotor)
    Cuando el usuario abre la pantalla "Tus Espacios"
    Entonces el sistema deberá mostrar el título "Propiedades guardadas [tipo de espacio]"
    Y el sistema deberá mostrar el mensaje "No hay propiedades a mostrar."

  Escenario: Vista de promotor autenticado
    Dado que el usuario ha iniciado sesión como promotor
    Cuando el usuario abre la pantalla "Tus Espacios"
    Entonces el sistema deberá mostrar el botón "Compra de espacios"
    Y el sistema deberá mostrar el título "Propiedades en espacios [tipo de espacio]"
    Y el sistema deberá mostrar la lista de propiedades del promotor

  Escenario: Menú superior para promotor
    Dado que el usuario es promotor
    Cuando el usuario abre la pantalla "Tus Espacios"
    Entonces el sistema deberá mostrar el menú superior de tipo de espacio

  Escenario: Navegación a compra de espacios
    Dado que el usuario es promotor
    Y se encuentra en la pantalla "Tus Espacios"
    Cuando el usuario presiona el botón "Compra de espacios"
    Entonces el sistema deberá navegar a la pantalla de compra de espacios
