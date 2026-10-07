# language: es
Característica: Conocidos y chat privado
  Como usuario autenticado
  Quiero invitar contactos y chatear de forma privada
  Para comunicarme con otros usuarios

  @REQ-CON-011 @mapeo-auto
  Escenario: Enviar invitación de contacto
    Dado que el usuario conoce el identificador de otro usuario
    Cuando envía una invitación de contacto
    Entonces el sistema registra la invitación

  @REQ-CON-011 @mapeo-auto
  Escenario: Aceptar invitación y chatear
    Dado que el usuario recibió una invitación
    Cuando acepta la solicitud
    Entonces el contacto queda disponible
    Y puede iniciar el chat privado
