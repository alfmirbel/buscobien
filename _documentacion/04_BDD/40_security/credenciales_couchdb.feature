# language: es
Característica: Gestión de Credenciales de CouchDB
  Como sistema
  Quiero obtener las credenciales de conexión a CouchDB desde variables de entorno
  Para autenticar todas las peticiones HTTP al backend

  Escenario: Carga de credenciales desde variables de entorno
    Dado que la aplicación se ejecuta con variables de entorno definidas
    Y `COUCHDB_USER` tiene el valor "admin"
    Y `COUCHDB_PASSWORD` tiene el valor "secret123"
    Y `COUCHDB_URL` tiene el valor "https://citigov.cloud:6984"
    Cuando el sistema carga el módulo de seguridad
    Entonces el sistema expone `username` con el valor "admin"
    Y expone `password` con el valor "secret123"
    Y expone `direccionip` con el valor "https://citigov.cloud:6984"

  Escenario: Uso de credenciales en autenticación Basic Auth
    Dado que el sistema necesita autenticar una petición HTTP
    Y `username` es "admin"
    Y `password` es "secret123"
    Cuando el sistema genera el encabezado de autorización
    Entonces el sistema codifica "admin:secret123" en base64
    Y genera el encabezado `Authorization: Basic YWRtaW46c2VjcmV0MTIz`

  Escenario: Credenciales vacías por defecto
    Dado que la aplicación se ejecuta sin variables de entorno definidas
    Cuando el sistema carga el módulo de seguridad
    Entonces el sistema expone `username` como cadena vacía
    Y expone `password` como cadena vacía
    Y expone `direccionip` como cadena vacía
