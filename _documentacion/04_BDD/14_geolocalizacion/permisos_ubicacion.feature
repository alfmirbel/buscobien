# language: es
Característica: Gestión de Permisos de Ubicación
  Como usuario final
  Quiero que la aplicación solicite y gestione los permisos de ubicación
  Para poder utilizar las funcionalidades de geolocalización

  Escenario: Servicios de ubicación deshabilitados
    Dado que el usuario está en una pantalla que requiere geolocalización
    Y los servicios de ubicación están deshabilitados en el dispositivo
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema debe mostrar el mensaje "La localización está deshabilitada."
    Y el permiso de localización debe permanecer en estado "denegado" (0)

  Escenario: Permiso de ubicación denegado por el usuario
    Dado que el usuario está en una pantalla que requiere geolocalización
    Y los servicios de ubicación están habilitados
    Y el usuario deniega el permiso de localización
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema debe mostrar el mensaje "Permiso de localización denegado."
    Y el permiso de localización debe permanecer en estado "denegado" (0)

  Escenario: Permiso de ubicación denegado permanentemente
    Dado que el usuario está en una pantalla que requiere geolocalización
    Y el permiso de localización fue denegado permanentemente
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema debe mostrar el mensaje "Localización negada permanentemente."
    Y el permiso de localización debe permanecer en estado "denegado" (0)

  Escenario: Permiso de ubicación concedido exitosamente
    Dado que el usuario está en una pantalla que requiere geolocalización
    Y los servicios de ubicación están habilitados
    Y el usuario concede el permiso de localización
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema debe obtener la posición actual del dispositivo
    Y actualizar la latitud y longitud en el estado
    Y mostrar el mensaje "La localización esta habilitada"
