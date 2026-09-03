# language: es
Característica: Generación y Validación de Tokens de Reset
  Como sistema
  Quiero generar tokens de reset de contraseña con expiración
  Para permitir a usuarios recuperar su cuenta de forma segura

  Escenario: Generación de token de reset
    Dado que el sistema necesita generar un token de reset
    Cuando el sistema ejecuta `generateResetToken()`
    Entonces el sistema genera un UUID v4
    Y aplica hash SHA256 al UUID
    Y retorna un token hexadecimal de 64 caracteres

  Escenario: Token generado es único
    Dado que el sistema genera un primer token de reset
    Y el sistema genera un segundo token de reset inmediatamente después
    Cuando compara ambos tokens
    Entonces ambos tokens son diferentes
    Y no hay colisión de tokens

  Escenario: Cálculo de expiración de token
    Dado que el sistema necesita generar un token con expiración
    Y la fecha actual es 2026-08-08 13:00:00 UTC
    Cuando el sistema ejecuta `generateTokenExpiry()`
    Entonces el sistema retorna la fecha actual + 1 hora
    Y la fecha está en formato ISO8601 UTC
    Y la fecha es 2026-08-08 14:00:00Z

  Escenario: Token válido antes de la expiración
    Dado que el sistema generó un token con expiración en 1 hora
    Y no ha pasado la fecha de expiración
    Cuando el sistema ejecuta `isTokenValid(fechaExpiracion)`
    Entonces el sistema retorna `true`

  Escenario: Token inválido después de la expiración
    Dado que el sistema generó un token con expiración hace 1 hora
    Y ya pasó la fecha de expiración
    Cuando el sistema ejecuta `isTokenValid(fechaExpiracion)`
    Entonces el sistema retorna `false`

  Escenario: Token inválido con formato incorrecto
    Dado que el sistema recibe un token con formato inválido (no ISO8601)
    Cuando el sistema ejecuta `isTokenValid("formato-invalido")`
    Entonces el sistema captura la excepción de parsing
    Y retorna `false`

  Escenario: Flujo completo de reset de contraseña
    Dado que un usuario solicita reset de contraseña
    Cuando el sistema genera el token de reset
    Y calcula la fecha de expiración (1 hora)
    Y envía el token al correo del usuario
    Entonces el usuario recibe un token válido por 1 hora
    Y el usuario puede usar el token para restablecer su contraseña
    Y después de 1 hora, el token ya no es válido
