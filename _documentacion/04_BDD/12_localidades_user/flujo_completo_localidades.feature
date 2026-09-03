# language: es
Característica: Flujo Completo de Localidades de Usuario
  Como usuario de BuscoBien
  Quiero completar el flujo de gestión de localidades
  Para mantener mi información de ubicación actualizada

  Antecedentes:
    Dado que el usuario "Juan Pérez" ha iniciado sesión
    Y su ID de usuario es "user-juan-123"

  Escenario: Flujo de registro de nueva localidad
    Dado que Juan no tiene localidades registradas
    Cuando Juan abre la pantalla de localidades
    Y el sistema carga sus localidades desde CouchDB
    Entonces el sistema deberá mostrar estado vacío
    Cuando Juan agrega una nueva localidad con código postal 06500
    Y el sistema consulta SEPOMEX y obtiene la localidad "Colonia Centro"
    Y Juan confirma la selección
    Entonces el sistema deberá guardar la localidad en `buscobien_user_localidad`
    Y el sistema deberá actualizar la sesión con la nueva localidad
    Y la localidad deberá aparecer en la lista de localidades de Juan

  Escenario: Flujo de cambio de localidad
    Dado que Juan tiene 2 localidades guardadas: "Centro" y "Polanco"
    Y su localidad actual es "Centro"
    Cuando Juan selecciona "Polanco"
    Entonces el sistema deberá actualizar la localidad seleccionada en el estado
    Y el sistema deberá sincronizar "Polanco" en el proveedor de sesión
    Y el sistema deberá reflejar el cambio en la UI

  Escenario: Flujo de eliminación de localidad
    Dado que Juan tiene la localidad "Centro" seleccionada
    Y tiene otra localidad "Polanco" disponible
    Cuando Juan elimina la localidad "Centro"
    Entonces el sistema deberá eliminar el documento de CouchDB
    Y el sistema deberá recargar la lista de localidades
    Y la localidad "Centro" deberá desaparecer de la lista
    Y la localidad "Polanco" debería pasar a ser la seleccionada o el sistema debería mostrar estado vacío

  Escenario: Flujo de búsqueda por código postal
    Dado que Juan desea agregar una nueva localidad
    Cuando Juan ingresa el código postal 11000
    Entonces el sistema deberá consultar SEPOMEX
    Y el sistema deberá mostrar las localidades disponibles para ese código postal
    Cuando Juan selecciona "Colonia Roma"
    Entonces el sistema deberá guardar la localidad asociada a Juan
