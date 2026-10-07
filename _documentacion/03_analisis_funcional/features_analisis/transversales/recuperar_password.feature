# language: es
Característica: Recuperación de contraseña por deep link
  Como usuario
  Quiero recuperar mi contraseña desde un correo
  Para restaurar el acceso a mi cuenta

  @REQ-AUTH-004 @REQ-AUTH-005 @mapeo-auto
  Escenario: Solicitud y flujo completo de recuperación
    Dado que el usuario solicitó recuperación de contraseña
    Y recibió el deep link por correo
    Cuando abre el deep link en la app
    Entonces el sistema navega a la pantalla de cambio de contraseña
    Y solicita el nuevo password
