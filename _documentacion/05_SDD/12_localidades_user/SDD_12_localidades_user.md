# SDD — Módulo 12_localidades_user (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/12_localidades_user`  
**Arquitectura:** Flutter + Riverpod + CouchDB  
**Bases de datos:** `buscobien_user_localidad`, `codigospostales` (catálogo SEPOMEX)

---

## 1. Requerimientos Ubicuos

### 1.1 Gestión de Localidades
- **REQ-LOC-001:** El sistema deberá permitir gestionar localidades asociadas al usuario autenticado.
- **REQ-LOC-002:** El sistema deberá almacenar las localidades en la base de datos `buscobien_user_localidad`.
- **REQ-LOC-003:** El sistema deberá sincronizar las localidades del usuario con el estado de sesión global.

### 1.2 Acceso a Datos
- **REQ-DAT-001:** El sistema deberá autenticar todas las peticiones HTTP mediante encabezado `Authorization: Basic`.
- **REQ-DAT-002:** El sistema deberá consultar las localidades del usuario mediante vistas CouchDB (`/_design/DDUL/_view/vistaUserID`).
- **REQ-DAT-003:** El sistema deberá consultar el catálogo de localidades SEPOMEX mediante vistas CouchDB (`/_design/DDCP/_view/vistaCP`).

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Carga de Localidades
- **REQ-CAR-001:** Cuando el usuario solicite cargar sus localidades, el sistema deberá consultar CouchDB con el ID de usuario como parámetro.
- **REQ-CAR-002:** Cuando la consulta retorne resultados, el sistema deberá actualizar el estado del proveedor `userLocalidadesProvider`.
- **REQ-CAR-003:** Cuando la consulta no retorne resultados, el sistema deberá establecer un estado vacío.

### 2.2 Consulta de Localidad por Asentamiento
- **REQ-CON-001:** Cuando el usuario solicite una localidad específica por asentamiento, el sistema deberá consultar CouchDB con `userId` y `asentamiento` como parámetros.
- **REQ-CON-002:** Cuando la consulta retorne resultados, el sistema deberá actualizar el estado con la localidad encontrada.

### 2.3 Guardado de Localidad
- **REQ-GUA-001:** Cuando el usuario guarde una localidad, el sistema deberá verificar previamente si ya existe una localidad con el mismo `userId` y `asentamiento`.
- **REQ-GUA-002:** Cuando la localidad no exista, el sistema deberá crear un nuevo documento en CouchDB con los datos de la localidad.
- **REQ-GUA-003:** Cuando la localidad ya exista, el sistema deberá retornar código 409 sin crear un nuevo documento.
- **REQ-GUA-004:** Cuando el guardado sea exitoso, el sistema deberá actualizar el timestamp de la localidad.

### 2.4 Eliminación de Localidad
- **REQ-ELI-001:** Cuando el usuario elimine una localidad, el sistema deberá obtener el documento actual para obtener la revisión (`_rev`).
- **REQ-ELI-002:** Cuando el sistema obtenga la revisión, el sistema deberá enviar una petición DELETE con el ID y la revisión.
- **REQ-ELI-003:** Cuando la eliminación sea exitosa, el sistema deberá recargar la lista de localidades del usuario.

### 2.5 Selección de Localidad
- **REQ-SEL-001:** Cuando el usuario seleccione una localidad desde el catálogo, el sistema deberá crear un nuevo objeto `UsuarioLocalidades` preservando los campos adicionales existentes.
- **REQ-SEL-002:** Cuando el usuario seleccione una localidad, el sistema deberá sincronizar la localidad con el proveedor de sesión.
- **REQ-SEL-003:** Cuando el usuario seleccione una localidad desde datos externos, el sistema deberá actualizar el estado y sincronizar con la sesión.

### 2.6 Catálogo SEPOMEX
- **REQ-SEP-001:** Cuando el usuario consulte un código postal, el sistema deberá realizar una petición GET a `codigospostales/_design/DDCP/_view/vistaCP?key=[cp]`.
- **REQ-SEP-002:** Cuando el código postal exista en el catálogo, el sistema deberá retornar la lista de localidades asociadas.
- **REQ-SEP-003:** Cuando el código postal no exista, el sistema deberá retornar una lista vacía.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Vacío
- **REQ-VAC-001:** Mientras la lista de localidades del usuario esté vacía, el sistema deberá mostrar un estado vacío indicando que no hay localidades registradas.

### 3.2 Estado: Con Datos
- **REQ-CON-ST-001:** Mientras el usuario tenga localidades guardadas, el sistema deberá mostrar la lista completa con todas las localidades.
- **REQ-CON-ST-002:** Mientras el usuario tenga localidades, el sistema deberá permitir seleccionar una localidad activa.

### 3.3 Estado: Cargando
- **REQ-CAR-ST-001:** Mientras el sistema carga las localidades desde CouchDB, el sistema deberá mostrar un indicador de progreso circular.

### 3.4 Estado: Error
- **REQ-ERR-ST-001:** Mientras ocurra un error de red al cargar localidades, el sistema deberá mostrar un estado de error con opción de reintentar.
- **REQ-ERR-ST-002:** Mientras ocurra un error al guardar una localidad, el sistema deberá mostrar un mensaje de error al usuario.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red y Servidor
- **REQ-FAL-001:** Si ocurre una excepción de red al cargar localidades, el sistema deberá retornar un estado vacío y registrar el error.
- **REQ-FAL-002:** Si ocurre una excepción al guardar una localidad, el sistema deberá retornar código 500.
- **REQ-FAL-003:** Si ocurre una excepción al eliminar una localidad, el sistema deberá retornar `false` indicando fallo.
- **REQ-FAL-004:** Si el servidor de CouchDB no responde, el sistema deberá manejar el timeout sin bloquear la UI.

### 4.2 Datos Ausentes
- **REQ-AUS-001:** Si el usuario no tiene datos de sesión cargados, el sistema deberá retornar código 500 al intentar cargar localidades.
- **REQ-AUS-002:** Si el ID de usuario está vacío, el sistema deberá retornar código 500 al intentar cargar localidades.
- **REQ-AUS-003:** Si la localidad a eliminar no existe en CouchDB, el sistema deberá retornar `false`.

### 4.3 Duplicados
- **REQ-DUP-001:** Si el usuario intenta guardar una localidad con el mismo `userId` y `asentamiento`, el sistema deberá retornar código 409 sin crear un duplicado.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Catálogo SEPOMEX
- **REQ-OPT-001:** Donde el catálogo de localidades esté disponible, el sistema deberá permitir buscar localidades por código postal.
- **REQ-OPT-002:** Donde el catálogo retorne resultados, el sistema deberá presentar las localidades disponibles para que el usuario seleccione una.

### 5.2 Sincronización con Sesión
- **REQ-OPT-003:** Donde el usuario seleccione una localidad, el sistema deberá sincronizar los datos con el proveedor de sesión global.
- **REQ-OPT-004:** Donde el usuario actualice su localidad, el sistema deberá reflejar los cambios en el estado de sesión inmediatamente.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Carga y Selección
- **REQ-COM-001:** Mientras el usuario carga sus localidades, cuando el sistema obtenga la lista desde CouchDB, entonces el sistema deberá actualizar el estado y permitir la selección de una localidad.

### 6.2 Flujo de Guardado con Sincronización
- **REQ-COM-002:** Mientras el usuario guarda una localidad, cuando el sistema verifique que no existe duplicado, entonces el sistema deberá crear el documento en CouchDB, actualizar el timestamp y sincronizar con la sesión.

### 6.3 Flujo de Eliminación con Recarga
- **REQ-COM-003:** Mientras el usuario elimina una localidad, cuando el sistema elimine el documento exitosamente, entonces el sistema deberá recargar la lista de localidades para reflejar los cambios.

### 6.4 Flujo de Búsqueda por Código Postal
- **REQ-COM-004:** Mientras el usuario busca una localidad por código postal, cuando el sistema consulte SEPOMEX, entonces el sistema deberá retornar las localidades disponibles y permitir al usuario seleccionar una para guardarla.

---

## 7. Modelos de Datos

### 7.1 UsuarioLocalidades
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `idCodigopostal` | String | ID del código postal |
| `idUsuario` | String | ID del usuario propietario |
| `pais` | String | País (default: "México") |
| `localidadCp` | LocalidadCp | Objeto de localidad (estado, municipio, ciudad, zona, cp, asentamiento, tipo) |
| `calle` | String | Calle |
| `seccionine` | String | Sección INE |
| `latitud` | String | Latitud |
| `longitud` | String | Longitud |
| `latDecimal` | String | Latitud decimal |
| `lonDecimal` | String | Longitud decimal |
| `timestamp` | String | Marca de tiempo de última actualización |

### 7.2 UsuarioLocalidadesGet (Wrapper)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `totalRows` | int | Total de filas |
| `offset` | int | Offset |
| `rows` | List<RowsUserLocal> | Lista de filas |

### 7.3 RowsUserLocal
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | String | ID del documento |
| `key` | String | Clave de la fila |
| `value` | UsuarioLocalidades | Valor de la localidad |

---

## 8. Proveedores Riverpod

| Proveedor | Tipo | Descripción |
|-----------|------|-------------|
| `userLocalidadesProvider` | NotifierProvider | Estado global de localidades del usuario |
| `getUserLocalidadesFutureProvider` | FutureProvider | Future para carga inicial de localidades |
| `localidadesRepositoryProvider` | Provider | Repositorio HTTP para operaciones de localidades |

---

## 9. Reglas de Negocio

- **RN-001:** Un usuario no puede tener dos localidades con el mismo asentamiento.
- **RN-002:** El timestamp de la localidad se actualiza automáticamente al guardar.
- **RN-003:** El ID de usuario se obtiene automáticamente desde la sesión actual.
- **RN-004:** Al seleccionar una localidad, se preservan los campos adicionales existentes (calle, sección INE, coordenadas).
- **RN-005:** Al eliminar una localidad, se recarga automáticamente la lista de localidades.

---

## 10. Endpoints CouchDB

| Operación | Método | Endpoint |
|-----------|--------|----------|
| Obtener localidades por usuario | GET | `buscobien_user_localidad/_design/DDUL/_view/vistaUserID?key=[userId]` |
| Obtener localidad por asentamiento | GET | `buscobien_user_localidad/_design/DDUL/_view/vistaUserAsentamiento?key=[userId,asentamiento]` |
| Guardar localidad | POST | `buscobien_user_localidad` |
| Eliminar localidad | DELETE | `buscobien_user_localidad/[id]?rev=[rev]` |
| Buscar por código postal | GET | `codigospostales/_design/DDCP/_view/vistaCP?key=[cp]` |

---

## 11. Estructura de Archivos

```
lib/12_localidades_user/
├── data_user_localidad.dart                 # Modelo UsuarioLocalidades (Freezed)
├── data_user_localidad_get.dart             # Modelos wrapper UsuarioLocalidadesGet, RowsUserLocal
├── provider_get_localidades_usuario.dart    # NotifierProvider y FutureProvider
└── localidades_repository.dart              # Repositorio HTTP para operaciones CRUD
```
