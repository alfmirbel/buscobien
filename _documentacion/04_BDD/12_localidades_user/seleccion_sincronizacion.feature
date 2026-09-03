# language: es
Característica: Selección y Actualización de Localidad en Sesión
  Como usuario de BuscoBien
  Quiero seleccionar mi localidad preferida
  Para que el sistema use mi ubicación en funcionalidades posteriores

  Antecedentes:
    Dado que el usuario ha iniciado sesión
    Y tiene localidades guardadas en el sistema

  Escenario: Seleccionar localidad desde lista de localidades
    Dado que el usuario tiene localidades guardadas
    Cuando el usuario selecciona una localidad de la lista
    Entonces el sistema deberá crear un nuevo objeto `UsuarioLocalidades` con los datos de la localidad seleccionada
    Y el sistema deberá preservar los campos de calle, secciónINE, latitud, longitud, latDecimal y lonDecimal existentes
    Y el sistema deberá actualizar el estado del proveedor de localidades
    Y el sistema deberá sincronizar la localidad con el proveedor de sesión

  Escenario: Actualizar localidad desde datos externos
    Dado que el sistema recibe datos de localidad desde una fuente externa
    Cuando el usuario confirma la selección
    Entonces el sistema deberá crear un nuevo objeto `UsuarioLocalidades` con los datos recibidos
    Y el sistema deberá preservar los campos adicionales del estado actual
    Y el sistema deberá actualizar el estado del proveedor de localidades
    Y el sistema deberá sincronizar la localidad con el proveedor de sesión

  Escenario: Resetear localidad seleccionada
    Dado que el usuario desea limpiar su localidad seleccionada
    Cuando el sistema resetea la localidad
    Entonces el sistema deberá establecer una localidad vacía con valores por defecto
    Y el sistema deberá actualizar la sesión con una `LocalidadCp` vacía

  Escenario: Agregar localidad a la lista
    Dado que el usuario tiene localidades guardadas
    Cuando el sistema agrega una nueva localidad
    Entonces el sistema deberá crear una nueva fila con la localidad
    Y si existe un placeholder, el sistema deberá reemplazarlo
    Y si no existe un placeholder, el sistema deberá agregar la nueva localidad al final de la lista
