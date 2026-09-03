# SDD — Módulo Tus Espacios (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/08_pantallas/tu_cuenta/tus_espacios`  
**Arquitectura:** Flutter + Riverpod + CouchDB (vistas y endpoints específicos por tipo de espacio)  
**Bases de datos:** `buscobien_compra_espacios`, `buscobien_espacios_normales`, `buscobien_espacios_destacados`, `buscobien_espacios_superdestacados`, `buscobien_espacios_oportunidades`, `buscobien_espacios_remates`

---

## 1. Requerimientos Ubicuos

### 1.1 Navegación y Acceso
- **REQ-NAV-001:** El sistema deberá presentar la pantalla "Tus Espacios" como punto de acceso a la gestión de propiedades y espacios publicitarios.
- **REQ-NAV-002:** El sistema deberá mostrar diferentes vistas según el tipo de usuario: invitado, usuario normal o promotor.
- **REQ-NAV-003:** El sistema deberá mostrar un menú superior de tipo de espacio cuando el usuario sea promotor.

### 1.2 Estado y Sesión
- **REQ-SES-001:** El sistema deberá consultar el proveedor de sesión para determinar el ID del usuario autenticado.
- **REQ-SES-002:** El sistema deberá consultar el proveedor de sesión para determinar si el usuario es promotor (`esPromotor`).
- **REQ-SES-003:** El sistema deberá resetear el estado de espacios al iniciar la pantalla.

### 1.3 Acceso a Datos
- **REQ-DAT-001:** El sistema deberá autenticar todas las peticiones HTTP mediante encabezado `Authorization: Basic`.
- **REQ-DAT-002:** El sistema deberá consultar las propiedades del usuario mediante vistas CouchDB (`/_design/DDUSER/_view/idUser/`).
- **REQ-DAT-003:** El sistema deberá actualizar las propiedades en CouchDB mediante operaciones PUT con `_id` y `_rev`.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Pantalla: Tus Espacios (Vista Principal)
- **REQ-TE-001:** Cuando el usuario abra la pantalla "Tus Espacios", el sistema deberá determinar la vista a mostrar según el tipo de usuario.
- **REQ-TE-002:** Cuando el usuario sea invitado, el sistema deberá mostrar el mensaje "No hay propiedades que mostrar" y dos botones de acceso.
- **REQ-TE-003:** Cuando el usuario sea usuario normal autenticado, el sistema deberá mostrar el título "Propiedades guardadas [tipo de espacio]" y el mensaje "No hay propiedades a mostrar."
- **REQ-TE-004:** Cuando el usuario sea promotor autenticado, el sistema deberá mostrar el botón "Compra de espacios", el título "Propiedades en espacios [tipo de espacio]" y la lista de propiedades.
- **REQ-TE-005:** Cuando el usuario presione "Compra de espacios", el sistema deberá navegar a la pantalla de compra de espacios.
- **REQ-TE-006:** Cuando el usuario presione "Ingresa como promotor/publicar propiedades" o "Ingresa como usuario para ver propiedades", el sistema deberá mostrar el diálogo de login.

### 2.2 Pantalla: Ficha de Propiedad
- **REQ-FP-001:** Cuando el sistema cargue una propiedad, el sistema deberá mostrar una tarjeta con tipo de propiedad, nombre, ubicación, precio y foto principal.
- **REQ-FP-002:** Cuando la propiedad no tenga foto principal, el sistema deberá mostrar el texto "Agrega fotos" en el lugar de la imagen.
- **REQ-FP-003:** Cuando la propiedad esté activa (`activa = 1`), el sistema deberá mostrar el ícono de visibilidad y el texto "PUBLICADA".
- **REQ-FP-004:** Cuando la propiedad no esté activa (`activa = 0`), el sistema deberá mostrar el ícono de visibilidad desactivada y el texto "SIN PUBLICAR".
- **REQ-FP-005:** Cuando el usuario presione "Modificar", el sistema deberá navegar a la pantalla de edición de la propiedad.
- **REQ-FP-006:** Cuando el usuario presione "Publicar" en una propiedad no activa, el sistema deberá mostrar el diálogo de confirmación de publicación.
- **REQ-FP-007:** Cuando el usuario presione "Dejar de publicar" en una propiedad activa, el sistema deberá mostrar el diálogo de confirmación de borrado de publicación.
- **REQ-FP-008:** Cuando el usuario presione "Eliminar el espacio de publicación" en una propiedad no activa, el sistema deberá mostrar el diálogo de confirmación de eliminación.
- **REQ-FP-009:** Cuando el usuario presione "Eliminar el espacio de publicación" en una propiedad activa, el sistema deberá mostrar el mensaje "Para borrar el espacio debes dejar de publicarlo."
- **REQ-FP-010:** Cuando el usuario presione sobre la foto principal, el sistema deberá navegar a la pantalla de fotos de la propiedad.
- **REQ-FP-011:** Cuando el usuario presione el ícono de ampliar, el sistema deberá navegar a la pantalla de detalle de la propiedad en modo pantalla completa.
- **REQ-FP-012:** Cuando el usuario presione una sección expandible (Características, Datos del contacto, Datos adicionales), el sistema deberá mostrar u ocultar el contenido correspondiente.

### 2.3 Pantalla: Edición de Propiedad (Stepper)
- **REQ-ED-001:** Cuando el usuario abra la pantalla de edición, el sistema deberá mostrar un Stepper con 5 pasos: Propiedad, Precio, Ubicación, Adicionales, Contacto.
- **REQ-ED-002:** Cuando el usuario presione "Siguiente", el sistema deberá avanzar al siguiente paso del Stepper.
- **REQ-ED-003:** Cuando el usuario presione "Anterior", el sistema deberá retroceder al paso anterior del Stepper.
- **REQ-ED-004:** Cuando el usuario presione un paso específico en el Stepper, el sistema deberá navegar directamente a ese paso.
- **REQ-ED-005:** Cuando el usuario presione "Guardar", el sistema deberá validar el formulario y guardar los cambios en CouchDB.
- **REQ-ED-006:** Cuando el usuario presione "Regresar", el sistema deberá cerrar la pantalla sin guardar cambios.
- **REQ-ED-007:** Cuando el usuario cambie el "Tipo de propiedad", el sistema deberá mostrar u ocultar campos condicionales según las matrices de tipo de propiedad.
- **REQ-ED-008:** Cuando el usuario cambie el "Tipo de transacción", el sistema deberá mostrar u ocultar los campos de precio correspondientes (venta/renta/mantenimiento).
- **REQ-ED-009:** Cuando el usuario marque un checkbox de datos adicionales, el sistema deberá mostrar el campo de texto correspondiente y establecer el valor en "si".
- **REQ-ED-010:** Cuando el usuario desmarque un checkbox de datos adicionales, el sistema deberá ocultar el campo de texto y establecer el valor en vacío.
- **REQ-ED-011:** Cuando el usuario guarde exitosamente, el sistema deberá mostrar el mensaje "Se actualizó correctamente" y cerrar la pantalla.

### 2.4 Publicación de Propiedades
- **REQ-PUB-001:** Cuando el usuario presione "Publicar" en una propiedad sin publicar, el sistema deberá crear un nuevo documento en la base de datos de publicaciones correspondiente.
- **REQ-PUB-002:** Cuando el usuario presione "Publicar" en una propiedad ya publicada, el sistema deberá actualizar el documento existente en la base de datos de publicaciones.
- **REQ-PUB-003:** Cuando el usuario presione "Dejar de publicar", el sistema deberá eliminar el documento de publicación de CouchDB.
- **REQ-PUB-004:** Cuando la publicación sea exitosa, el sistema deberá establecer `activa = 1` y guardar el ID de publicación en `fotoprincipal`.
- **REQ-PUB-005:** Cuando la despublicación sea exitosa, el sistema deberá establecer `activa = 0` y limpiar `fotoprincipal`.
- **REQ-PUB-006:** Cuando el sistema publique una propiedad, el sistema deberá actualizar la propiedad en CouchDB con los nuevos valores de `activa`, `fotoprincipal`, `fechadepublicacioncasa` y `timestampcasa`.

### 2.5 Compra de Espacios
- **REQ-COM-001:** Cuando el usuario abra la pantalla "Compra de Espacios", el sistema deberá mostrar el formulario con campos para números de espacios, costos, impuestos, gran total y forma de pago.
- **REQ-COM-002:** Cuando el usuario presione "Comprar", el sistema deberá validar el formulario y procesar la compra.
- **REQ-COM-003:** Cuando el sistema procese la compra, el sistema deberá generar un ID de transacción único usando `idUsuario + timestamp + número aleatorio`, aplicando hash SHA1.
- **REQ-COM-004:** Cuando la compra sea exitosa, el sistema deberá guardar el registro en `buscobien_compra_espacios`.
- **REQ-COM-005:** Cuando la compra sea exitosa, el sistema deberá crear espacios automáticamente en las bases de datos correspondientes según el tipo de anuncio: normales, destacados, superdestacados, oportunidades, remates.
- **REQ-COM-006:** Cuando el sistema cree espacios comprados, el sistema deberá generar un `idPropiedad` único usando SHA1 y una `clavedelapropiedad` de 8 caracteres extraídos del hash.
- **REQ-COM-007:** Cuando el usuario presione "Cancelar", el sistema deberá cerrar la pantalla sin procesar la compra.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Invitado
- **REQ-INV-001:** Mientras el usuario sea invitado, el sistema deberá mostrar el mensaje "No hay propiedades que mostrar".
- **REQ-INV-002:** Mientras el usuario sea invitado, el sistema deberá mostrar dos botones que redirigen al diálogo de login.

### 3.2 Estado: Usuario Normal
- **REQ-USN-001:** Mientras el usuario sea usuario normal autenticado, el sistema deberá mostrar el título "Propiedades guardadas [tipo de espacio]".
- **REQ-USN-002:** Mientras el usuario sea usuario normal autenticado, el sistema deberá mostrar el mensaje "No hay propiedades a mostrar."

### 3.3 Estado: Promotor
- **REQ-PRO-001:** Mientras el usuario sea promotor, el sistema deberá mostrar el menú superior de tipo de espacio.
- **REQ-PRO-002:** Mientras el usuario sea promotor, el sistema deberá mostrar el botón "Compra de espacios".
- **REQ-PRO-003:** Mientras el usuario sea promotor, el sistema deberá mostrar la lista de propiedades del promotor.

### 3.4 Estado: Cargando
- **REQ-CAR-001:** Mientras la lista de propiedades se encuentra en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-002:** Mientras las fotos de la propiedad se cargan, el sistema deberá mostrar un indicador de carga en el lugar de la imagen.

### 3.5 Estado: Error
- **REQ-ERR-001:** Mientras ocurra un error al cargar las propiedades, el sistema deberá mostrar el estado de error correspondiente.
- **REQ-ERR-002:** Mientras ocurra un error al cargar las fotos, el sistema deberá mostrar el texto "No se encontró foto".

### 3.6 Estado: Publicación
- **REQ-PUB-ST-001:** Mientras la propiedad tiene `activa = 0`, el sistema deberá mostrar el estado "SIN PUBLICAR".
- **REQ-PUB-ST-002:** Mientras la propiedad tiene `activa = 1`, el sistema deberá mostrar el estado "PUBLICADA".
- **REQ-PUB-ST-003:** Mientras el sistema está procesando la publicación, el sistema deberá mostrar un indicador de carga circular en el diálogo y deshabilitar los botones.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red y Servidor
- **REQ-FAL-001:** Si ocurre una excepción de red al cargar las propiedades, el sistema deberá registrar el error y mostrar estado vacío.
- **REQ-FAL-002:** Si ocurre una excepción al actualizar la propiedad en CouchDB, el sistema deberá mostrar el mensaje "Error: no se pudo actualizar el espacio" y restaurar el estado original.
- **REQ-FAL-003:** Si ocurre una excepción al publicar la propiedad, el sistema deberá mostrar el mensaje "Error: no se pudo publicar" y restaurar `activa = 0` y `fotoprincipal = ""`.
- **REQ-FAL-004:** Si la base de datos de compras no existe, el sistema deberá manejar el error 404 y retornar estado vacío.
- **REQ-FAL-005:** Si ocurre una excepción al crear espacios comprados, el sistema deberá registrar el error y retornar resultado 400.

### 4.2 Validaciones
- **REQ-VAL-001:** Si el usuario deja campos obligatorios vacíos en el formulario de compra, el sistema deberá mostrar el mensaje "El campo es obligatorio" e impedir el envío.
- **REQ-VAL-002:** Si el usuario intenta guardar el formulario de edición con campos inválidos, el sistema deberá impedir el guardado.
- **REQ-VAL-003:** Si el usuario intenta eliminar una propiedad publicada sin antes dejarla de publicar, el sistema deberá mostrar el mensaje "Para borrar el espacio debes dejar de publicarlo."

### 4.3 Datos Ausentes
- **REQ-AUS-001:** Si la propiedad no tiene `idPropiedad`, el sistema deberá generar un ID único usando SHA1.
- **REQ-AUS-002:** Si la propiedad no tiene `clavedelapropiedad`, el sistema deberá generar una clave de 8 caracteres extraídos del hash SHA1.
- **REQ-AUS-003:** Si la lista de propiedades está vacía, el sistema deberá mostrar el mensaje "No tienes espacios en [tipo de espacio]."

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Compra de Espacios
- **REQ-OPT-001:** Donde el usuario sea promotor, el sistema deberá permitir acceder a la pantalla de compra de espacios publicitarios.
- **REQ-OPT-002:** Donde el usuario compre espacios, el sistema deberá generar documentos de propiedad automáticamente en las bases de datos correspondientes al tipo de anuncio.
- **REQ-OPT-003:** Donde el usuario compre espacios, el sistema deberá generar IDs de propiedad únicos usando SHA1 y claves de propiedad de 8 caracteres.

### 5.2 Publicación de Propiedades
- **REQ-OPT-004:** Donde el usuario publique una propiedad, el sistema deberá crear/actualizar documentos en la base de datos de publicaciones correspondiente al tipo de anuncio.
- **REQ-OPT-005:** Donde el usuario des publique una propiedad, el sistema deberá eliminar el documento de publicación y actualizar el estado de la propiedad.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Publicación con Rollback
- **REQ-COM-001:** Mientras el usuario publique una propiedad, cuando el sistema cree la publicación exitosamente pero falle al actualizar la propiedad en CouchDB, entonces el sistema deberá eliminar la publicación creada y restaurar el estado original de la propiedad (`activa = 0`, `fotoprincipal = ""`).

### 6.2 Flujo de Edición con Validación
- **REQ-COM-002:** Mientras el usuario edite una propiedad en el Stepper, cuando el usuario presione "Guardar" sin completar campos obligatorios, entonces el sistema deberá mostrar errores de validación en los campos vacíos e impedir el guardado.

### 6.3 Flujo de Compra con Creación de Espacios
- **REQ-COM-003:** Mientras el usuario realice una compra de espacios, cuando el sistema registre la compra exitosamente en `buscobien_compra_espacios`, entonces el sistema deberá crear automáticamente los espacios comprados en las bases de datos correspondientes según cada tipo de anuncio.

### 6.4 Flujo de Navegación por Tipo de Usuario
- **REQ-COM-004:** Mientras el usuario abra "Tus Espacios", cuando el sistema determine que el usuario es invitado, entonces el sistema deberá mostrar la vista de invitado con botones de login; cuando el sistema determine que es usuario normal, entonces el sistema deberá mostrar la vista de propiedades guardadas vacía; cuando el sistema determine que es promotor, entonces el sistema deberá mostrar la vista de promotor con lista de propiedades y botón de compra.

---

## 7. Modelos de Datos

### 7.1 EspaciosCasa (Propiedad)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | ID único del documento |
| `_rev` | String | Revisión CouchDB |
| `versiondelformato` | String | Versión del formato |
| `idPropiedad` | String | ID único de la propiedad |
| `clavedelapropiedad` | String | Clave corta de 8 caracteres |
| `idusuario` | String | ID del usuario propietario |
| `tipodeanuncio` | String | Tipo de anuncio (normal/destacado/etc.) |
| `tipodepropiedad` | String | Tipo de inmueble |
| `tipodetransaccion` | String | Tipo de transacción |
| `idTransaccion` | String | ID de transacción |
| `nombredelapropiedad` | String | Nombre de la propiedad |
| `descripcion` | String | Descripción |
| `ubicacioncasa` | Object | Datos de ubicación (país, estado, municipio, etc.) |
| `datosdelcontactocasa` | Object | Datos de contacto |
| `datosadicionalescasa` | Object | Características adicionales |
| `fotoprincipal` | String | ID de la foto principal o ID de publicación |
| `activa` | int | 0 = sin publicar, 1 = publicada |
| `timestampcasa` | String | Marca de tiempo |

### 7.2 CompraEspacio
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `versiondelformato` | String | Versión del formato |
| `idUsuario` | String | ID del usuario comprador |
| `idTransaccion` | String | ID de transacción (SHA1) |
| `noDeEspaciosNormales` | int | Cantidad de espacios normales |
| `noDeEspaciosDestacados` | int | Cantidad de espacios destacados |
| `noDeEspaciosSuperdestacados` | int | Cantidad de espacios superdestacados |
| `noDeEspaciosOportunidades` | int | Cantidad de espacios oportunidades |
| `noDeEspaciosRemates` | int | Cantidad de espacios remates |
| `fechaDeCompra` | FechaDe | Fecha de compra (día, mes, año) |
| `fechaDePago` | FechaDe | Fecha de pago (día, mes, año) |
| `medioDePago` | String | Medio de pago |
| `referenciaDePago` | String | Referencia de pago |
| `mesesContratados` | int | Meses contratados |
| `vencimiento` | String | Fecha de vencimiento |
| `vigente` | int | Estado de vigencia |
| `totalEspacioNormal` | double | Total espacios normales |
| `totalEspacioDestacado` | double | Total espacios destacados |
| `totalEspacioSuperdestacado` | double | Total espacios superdestacados |
| `totalEspaciosOportunidades` | double | Total espacios oportunidades |
| `totalEspaciosRemates` | double | Total espacios remates |
| `impuestos` | double | Impuestos (IVA) |
| `granTotal` | double | Gran total |
| `timestamp` | String | Marca de tiempo |

### 7.3 Endpoints CouchDB por Tipo de Espacio
| Tipo de Espacio | Base de Datos Captura | Base de Datos Publicado |
|-----------------|----------------------|------------------------|
| Normales | `buscobien_espacios_normales` | `buscobien_publicados_normales` |
| Destacados | `buscobien_espacios_destacados` | `buscobien_publicados_destacados` |
| Superdestacados | `buscobien_espacios_superdestacados` | `buscobien_publicados_superdestacados` |
| Oportunidades | `buscobien_espacios_oportunidades` | `buscobien_publicados_oportunidades` |
| Remates | `buscobien_espacios_remates` | `buscobien_publicados_remates` |

---

## 8. Proveedores Riverpod

| Proveedor | Tipo | Descripción |
|-----------|------|-------------|
| `espaciosCasaConListaFotosGetProvider` | NotifierProvider | Estado global de espacios del usuario con índice y fotos |
| `listaEspaciosCasaFutureProvider` | FutureProvider | Future para carga inicial de propiedades |
| `compraDeEspaciosProvider` | NotifierProvider | Estado del formulario de compra de espacios |
| `getCompraEspaciosFutureProvider` | FutureProvider | Future para escritura de compra en CouchDB |
| `sessionProvider` | NotifierProvider | Estado de sesión del usuario |

---

## 9. Reglas de Negocio

- **RN-001:** El ID de transacción se genera como SHA1 de: `idUsuario + timestamp + número aleatorio (1000-9999)`.
- **RN-002:** La clave de propiedad se genera extrayendo 8 caracteres del hash SHA1 del ID de propiedad.
- **RN-003:** Los espacios comprados se crean con `activa = 0` (no publicados) por defecto.
- **RN-004:** La publicación de una propiedad actualiza `activa = 1`, `fotoprincipal = ID_publicacion`, y timestamps de publicación.
- **RN-005:** La despublicación de una propiedad actualiza `activa = 0`, `fotoprincipal = ""`.
- **RN-006:** Los campos de edición son condicionales según el tipo de propiedad y tipo de transacción.
- **RN-007:** Los datos adicionales se representan como checkboxes que habilitan campos de texto condicionales.
- **RN-008:** Un usuario invitado no puede ver propiedades, solo acceder a login.
- **RN-009:** Un usuario normal autenticado ve la lista de propiedades vacía (solo para extensión futura).
- **RN-010:** Solo los promotores pueden comprar espacios y publicar propiedades.

---

## 10. Matrices de Campos por Tipo de Propiedad

### 10.1 Matriz de Campos Condicionales
| Campo | Tipos de Propiedad Aplicables |
|-------|------------------------------|
| `metrosdeterreno` | Casa, Bodega, Edificio, Accesoria, Lote, Terreno, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `metrosconstruidos` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Rancho, Quinta, Villa, Nave industrial, Otro tipo |
| `recamaras` | Casa, Departamento, Quinta, Villa, Otro tipo |
| `banos` | Casa, Departamento, Oficina, Accesoria, Local, Quinta, Villa, Otro tipo |
| `mediosbanos` | Casa, Departamento, Oficina, Accesoria, Local, Quinta, Villa, Otro tipo |
| `cuartosdeservicio` | Casa, Departamento, Quinta, Villa, Otro tipo |
| `estacionamientos` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Quinta, Villa, Otro tipo |
| `estacionamientoscubiertos` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Quinta, Villa, Otro tipo |
| `precioventa` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Lote, Terreno, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `preciorenta` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Lote, Terreno, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `mantenimiento` | Casa, Departamento, Oficina, Local, Otro tipo |
| `moneda` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Lote, Terreno, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |

### 10.2 Datos Adicionales por Tipo de Propiedad
| Característica | Tipos Aplicables |
|----------------|------------------|
| `panelessolares` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Rancho, Quinta, Villa, Otro tipo |
| `jardin` | Casa, Otro tipo |
| `alberca` | Casa, Departamento, Rancho, Quinta, Villa, Otro tipo |
| `calefaccion` | Casa, Departamento, Oficina, Bodega, Edificio, Rancho, Quinta, Villa, Otro tipo |
| `aireacondicionado` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Quinta, Villa, Otro tipo |
| `seguridad` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Quinta, Villa, Otro tipo |
| `enfraccionamiento` | Casa, Departamento, Edificio, Otro tipo |
| `casasenelconjunto` | Casa, Departamento, Edificio, Otro tipo |
| `casaclub` | Casa, Departamento, Otro tipo |
| `salondeeventos` | Casa, Departamento, Otro tipo |
| `centrodenegocios` | Casa, Departamento, Otro tipo |
| `gimnacio` | Casa, Departamento, Otro tipo |
| `cisterna` | Casa, Departamento, Accesoria, Bodega, Local, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `almacenamientodeagua` | Casa, Departamento, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `tratamientodeaguas` | Casa, Departamento, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
| `otrascaracteristicas` | Casa, Departamento, Oficina, Accesoria, Bodega, Local, Edificio, Lote, Terreno, Rancho, Quinta, Villa, Huerta, Nave industrial, Otro tipo |
