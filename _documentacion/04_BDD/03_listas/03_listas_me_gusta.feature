# language: es
Característica: Me Gusta y Lista Favoritas
  Como usuario autenticado
  Quiero marcar propiedades como favoritas
  Para acceder rápidamente a los inmuebles que más me interesan

  Escenario: El usuario marca una propiedad como "Me gusta" por primera vez
    Dado que el usuario está autenticado
    Y no tiene una lista "Favoritas" creada
    Cuando el usuario presiona el botón de "Me gusta" en una propiedad
    Entonces el sistema debe crear automáticamente la lista "Favoritas"
    Y debe agregar la propiedad a esa lista
    Y debe registrar el "Me gusta" en la base de datos
    Y el botón de "Me gusta" debe cambiar a estado activo

  Escenario: El usuario agrega una propiedad a Favoritas existente
    Dado que el usuario ya tiene una lista "Favoritas"
    Cuando el usuario presiona "Me gusta" en una propiedad nueva
    Entonces el sistema debe agregar la propiedad a la lista "Favoritas"
    Y no debe crear una nueva lista duplicada
    Y el botón de "Me gusta" debe cambiar a estado activo

  Escenario: El usuario quita el "Me gusta" de una propiedad
    Dado que el usuario había marcado una propiedad como "Me gusta"
    Cuando el usuario presiona el botón de "Me gusta" nuevamente
    Entonces el sistema debe eliminar el registro de "Me gusta"
    Y el botón debe cambiar a estado inactivo

  Escenario: El sistema previene duplicados en la lista Favoritas
    Dado que una propiedad ya está en la lista "Favoritas"
    Cuando el usuario intenta marcarla como "Me gusta" nuevamente
    Entonces el sistema debe detectar que la propiedad ya existe en la lista
    Y no debe crear una relación duplicada
    Y no debe mostrar ningún mensaje de error

  Escenario: La lista "Favoritas" siempre aparece primera en "Mis Listas"
    Dado que el usuario tiene varias listas creadas
    Cuando se cargan las listas del usuario
    Entonces el sistema debe reordenar las listas para que "Favoritas" esté en el índice 0
    Y las demás listas deben mantenener su orden relativo

  Escenario: El estado de "Me gusta" se refleja reactivamente en la UI
    Dado que el usuario tiene sesión activa
    Y ha cargado sus "Me gusta" previamente
    Cuando navega por las propiedades
    Entonces el sistema debe mostrar el botón de "Me gusta" en estado activo para las propiedades favoritas
    Y en estado inactivo para las propiedades no favoritas

  Escenario: El sistema carga los "Me gusta" al iniciar sesión
    Dado que el usuario cierra sesión y vuelve a iniciar sesión
    Cuando la pantalla principal se monta
    Entonces el sistema debe cargar los "Me gusta" del usuario automáticamente
    Y la lista "Favoritas" debe contener todas las propiedades marcadas previamente
