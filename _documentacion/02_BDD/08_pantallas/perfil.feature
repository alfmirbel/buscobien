# language: es
Característica: Perfil de usuario
  Como usuario autenticado
  Quiero ver y gestionar mi perfil y avatar
  Para mantener actualizada mi información personal

  Escenario: Visualización del perfil desde la sesión
    Dado que el usuario tiene una sesión activa
    Cuando abre la pantalla de Perfil
    Entonces el sistema muestra los datos de usuario desde la sesión

  Escenario: Gestión de avatar desde Perfil
    Dado que el usuario está en la pantalla de Perfil
    Cuando accede a la gestión de avatar
    Entonces el sistema expone las acciones de selección y actualización de avatar
