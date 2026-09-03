# language: es
Característica: Cifrado y Descifrado AES
  Como sistema
  Quiero cifrar y descifrar datos sensibles usando AES
  Para proteger información almacenada localmente

  Escenario: Generación de clave y vector de inicialización seguros
    Dado que el sistema necesita inicializar cifrado AES
    Cuando el sistema crea una clave de 32 bytes con `Key.fromSecureRandom(32)`
    Y crea un IV de 16 bytes con `IV.fromSecureRandom(16)`
    Entonces el sistema obtiene una clave de 256 bits
    Y obtiene un vector de inicialización de 128 bits

  Escenario: Cifrado de texto plano
    Dado que el sistema tiene una clave AES y un IV
    Y el texto plano es "datos sensibles"
    Cuando el sistema ejecuta `encrypter.encrypt("datos sensibles", iv: iv16)`
    Entonces el sistema retorna un texto cifrado
    Y el texto cifrado no es igual al texto plano
    Y el texto cifrado se puede desencriptar

  Escenario: Descifrado de texto cifrado
    Dado que el sistema tiene un texto cifrado con AES
    Y tiene la clave y IV originales
    Cuando el sistema ejecuta `encrypter.decrypt(encrypted, iv: iv16)`
    Entonces el sistema retorna el texto plano original
    Y el texto descifrado es igual al original

  Escenario: Descifrado fallido con clave incorrecta
    Dado que el sistema tiene un texto cifrado con AES
    Y tiene una clave diferente a la original
    Cuando el sistema intenta descifrar con la clave incorrecta
    Entonces el sistema retorna un texto que no es el original
    O lanza una excepción de descifrado

  Escenario: Almacenamiento seguro con flutter_secure_storage (recomendado)
    Dado que el sistema necesita almacenar credenciales de forma segura
    Cuando el sistema usa `flutter_secure_storage` en lugar de AES manual
    Entonces el sistema almacena los datos en el keychain/keystore del sistema
    Y los datos están protegidos por el sistema operativo
    Y no se almacenan en SharedPreferences inseguro

  Escenario: Funciones AES legacy marcadas como deprecated
    Dado que el sistema tiene funciones AES legacy (`decryptWithAES`, `encryptWithAES`)
    Y el sistema migra a `flutter_secure_storage`
    Cuando el sistema compila con advertencias
    Entonces las funciones legacy siguen funcionando
    Pero muestran advertencia `@Deprecated('Usa flutter_secure_storage en su lugar')`
