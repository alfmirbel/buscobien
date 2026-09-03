# language: es
Característica: Gestión de Localidades de Usuario
  Como usuario de BuscoBien
  Quiero gestionar mis localidades y direcciones
  Para seleccionar mi ubicación preferida en el sistema

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y el sistema tiene acceso a los datos del usuario

  Escenario: Carga inicial de localidades del usuario
    Dado que el usuario abre la pantalla de localidades
    Entonces el sistema deberá consultar las localidades guardadas del usuario en CouchDB
    Y el sistema deberá mostrar la lista de localidades disponibles

  Escenario: Estado vacío de localidades
    Dado que el usuario no tiene localidades guardadas
    Cuando la carga finalice
    Entonces el sistema deberá mostrar un estado vacío indicando que no hay localidades registradas

  Escenario: Selección de localidad
    Dado que el usuario tiene varias localidades guardadas
    Cuando el usuario selecciona una localidad
    Entonces el sistema deberá actualizar la localidad seleccionada en el estado
    Y el sistema deberá sincronizar la localidad con el proveedor de sesión
