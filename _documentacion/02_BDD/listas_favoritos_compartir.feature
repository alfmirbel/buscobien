# language: es
Característica: Listas, favoritos y compartir
  Como usuario autenticado
  Quiero organizar propiedades en listas, marcarlas como favoritas y compartirlas
  Para gestionar mis espacios de interés

  Escenario: Crear lista y agregar propiedad
    Dado que el usuario está autenticado
    Y crea una lista llamada "Departamentos en renta"
    Cuando agrega una propiedad a esa lista
    Entonces la propiedad aparece en la lista seleccionada

  Escenario: Me gusta y auto-creación de Favoritas
    Dado que el usuario marca "Me gusta" en una propiedad
    Y no existe la lista "Favoritas"
    Cuando confirma la acción
    Entonces el sistema crea "Favoritas"
    Y agrega la propiedad

  Escenario: Compartir lista con contactos
    Dado que el usuario tiene una lista existente
    Y abre el flujo de compartir
    Cuando selecciona hasta 5 contactos conocidos
    Y confirma el envío
    Entonces la lista compartida queda registrada
    Y el destinatario recibe la invitación
