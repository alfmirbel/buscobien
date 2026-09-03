# language: es
Característica: Generación y Validación de Hashes
  Como sistema
  Quiero generar y validar hashes criptográficos de contraseñas
  Para almacenar y verificar credenciales de usuarios de forma segura

  Escenario: Generación de hash MD5
    Dado que el sistema necesita generar un hash MD5
    Y la entrada es "password123"
    Cuando el sistema ejecuta `generateMD5Hash`
    Entonces el sistema retorna el hash MD5 de "password123"
    Y el hash tiene 32 caracteres hexadecimales

  Escenario: Generación de hash SHA1
    Dado que el sistema necesita generar un hash SHA1
    Y la entrada es "password123"
    Cuando el sistema ejecuta `generateSHA1Hash`
    Entonces el sistema retorna el hash SHA1 de "password123"
    Y el hash tiene 40 caracteres hexadecimales

  Escenario: Generación de hash SHA256
    Dado que el sistema necesita generar un hash SHA256
    Y la entrada es "password123"
    Cuando el sistema ejecuta `generateSHA256Hash`
    Entonces el sistema retorna el hash SHA256 de "password123"
    Y el hash tiene 64 caracteres hexadecimales

  Escenario: Validación de password con hash SHA256
    Dado que el sistema almacenó el hash SHA256 de "miPassword"
    Y el usuario intenta autenticarse con "miPassword"
    Cuando el sistema ejecuta `validaPassword("miPassword", hashAlmacenado)`
    Entonces el sistema retorna `true`
    Y el usuario es autenticado exitosamente

  Escenario: Rechazo de password incorrecto
    Dado que el sistema almacenó el hash SHA256 de "miPassword"
    Y el usuario intenta autenticarse con "passwordIncorrecta"
    Cuando el sistema ejecuta `validaPassword("passwordIncorrecta", hashAlmacenado)`
    Entonces el sistema retorna `false`
    Y el usuario no es autenticado

  Escenario: Hash determinista para misma entrada
    Dado que el sistema genera un hash SHA256 de "test123"
    Y genera otro hash SHA256 de "test123"
    Cuando compara ambos hashes
    Entonces ambos hashes son idénticos
    Y el sistema puede validar passwords consistentemente
