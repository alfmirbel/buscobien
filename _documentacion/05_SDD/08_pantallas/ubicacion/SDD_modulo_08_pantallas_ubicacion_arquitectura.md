# SDD — Módulo `lib/08_pantallas/ubicacion` — Especificación de Arquitectura
## Especificación General del Módulo de Ubicación
**Módulo:** `lib/08_pantallas/ubicacion/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_principal_localidades.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla principal de localidades del usuario; muestra localidades guardadas y botones para buscar/localización |
| `screen_maestro_localidades.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla maestra de localidades por código postal (`LocalidadesListScreen`); lista resultados con opción de guardar |
| `pagina_busca_localidades_gmaps.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de búsqueda de localidades por CP con mapa Google Maps integrado |
| `provider_localidades_del_cp.dart` | Fuente — Riverpod `NotifierProvider` | Gestiona localidades por código postal (`localidadesPorCodigoPostalProvider`); obtiene, selecciona y resetea localidades |
| `data_sepomex_localidades.dart` | Fuente — Modelo de Datos | Define modelos de localidades SEPOMEX (`LocalidadesGet`, `RowLocalidadesGet`, `ValueLocalidadesGet`) |
| `data_sepomex_localidades_get_cp.dart` | Fuente — Modelo de Datos | Define modelo de respuesta de localidades por CP |
| `data_sepomex_localidades.freezed.dart` | Generado | Código generado por Freezed para modelos de localidades |
| `data_sepomex_localidades.g.dart` | Generado | Código generado por `json_serializable` |
| `data_localidad_find.dart` | Fuente — Modelo de Datos | Define modelo para búsqueda de localidades |
| `data_models/` | Directorio | Contiene modelos adicionales de localidades |
| `pagina_detalle_propiedad_pdf.dart` | Fuente — Servicio | Generación de PDF de propiedades (relacionado con detalles) |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras las pantallas de ubicación estén activas.

**SDD-UBI-001**
El sistema deberá renderizar las pantallas de ubicación (`PaginaPrincipalListaLocalidades`, `LocalidadesListScreen`, `PaginaBuscaLocalidadGMaps`) como `ConsumerStatefulWidget` para acceder a providers de sesión, localidades y tema.

**SDD-UBI-002**
El sistema deberá utilizar `appTheme` (ColorScheme M3) como fuente única de colores en todas las pantallas de ubicación, evitando hardcodear valores hexadecimales excepto para casos específicos de marca.

**SDD-UBI-003**
El sistema deberá limitar el ancho máximo del contenido mediante `ConstrainedBox` con `maxWidth: desktopContentMaxWidth` en `PaginaPrincipalListaLocalidades` y `PaginaBuscaLocalidadGMaps`, garantizando legibilidad en pantallas anchas.

**SDD-UBI-004**
El sistema deberá gestionar el estado de localidades exclusivamente mediante Riverpod (`localidadesPorCodigoPostalProvider`, `userLocalidadesProvider`, `ubicacionActualProvider`), garantizando reactividad automática ante cambios.

**SDD-UBI-005**
El sistema deberá manejar la navegación desde pantallas de ubicación mediante `Navigator.pushNamed` o `Navigator.pushReplacementNamed` hacia `AppRoutes.principal` o `AppRoutes.listalocalidades`, según el flujo.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-UBI-010**
Cuando el usuario presione el botón "Ingresa como usuario para guardar propiedades" en `PaginaPrincipalListaLocalidades`, el sistema deberá abrir `dialogBoxFichaLogin(context, ref)` si `userId` está vacío.

**SDD-UBI-011**
Cuando el usuario presione el botón "Selecciona localidades para ver publicaciones de la zona", el sistema deberá navegar a `AppRoutes.localidades` (`PaginaBuscaLocalidadGMaps`) con `arguments: ""`.

**SDD-UBI-012**
Cuando el usuario presione el botón de eliminar en una tarjeta de localidad, el sistema deberá mostrar un `AlertDialog` con título "Eliminar Ubicación" y mensaje "¿Deseas eliminar la ubicación {asentamiento}?".

**SDD-UBI-013**
Cuando el usuario confirme la eliminación de una localidad, el sistema deberá llamar a `deleteUserLocalidadFromCouchDB(loc.id)` y actualizar la lista de localidades del usuario.

**SDD-UBI-014**
Cuando el usuario presione una localidad en `LocalidadesListScreen`, el sistema deberá actualizar `localidadesPorCodigoPostalProvider` con la localidad seleccionada (`setLocalidadActual(index)`), actualizar la sesión (`updateLocalidadEnSesion`) y navegar a `AppRoutes.principal`.

**SDD-UBI-015**
Cuando el usuario presione "Sí, guardar" en el diálogo de guardado de localidad, el sistema deberá llamar a `writeUserLocalidadToCouchDB(userLocal)` y, si el resultado es 200, refrescar `fetchLocalidadesDeUsuario()`.

**SDD-UBI-016**
Cuando el usuario presione "No" en el diálogo de guardado, el sistema deberá navegar a `AppRoutes.principal` sin guardar la localidad.

**SDD-UBI-017**
Cuando el usuario presione "Busca ubicaciones" en `PaginaBuscaLocalidadGMaps`, el sistema deberá validar el formulario, guardar el CP (`setCodigoPostal`), refrescar `getLocalidadesDelCPFutureProvider` y navegar a `AppRoutes.listalocalidades`.

**SDD-UBI-018**
Cuando el mapa se cree (`onMapCreated`), el sistema deberá llamar a `ubicacionActualProvider.notifier.onMapCreated(mapController)` para guardar el controlador del mapa.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-UBI-020**
Mientras `userId` esté vacío en `PaginaPrincipalListaLocalidades`, el sistema deberá mostrar el botón de login con ícono `iconoUsuario` y texto "Ingresa como usuario para guardar propiedades".

**SDD-UBI-021**
Mientras `userId` no esté vacío, el sistema deberá ocultar el botón de login mostrando un `SizedBox(height: 0)`.

**SDD-UBI-022**
Mientras `localidadesUsuario` tenga localidades con `cp != 0`, el sistema deberá mostrar las tarjetas de localidades en un `ListView.builder` o `Column` con `Card`.

**SDD-UBI-023**
Mientras no hay localidades guardadas, el sistema deberá mostrar solo los botones de acción (login y buscar) sin tarjetas de localidades.

**SDD-UBI-024**
Mientras `getLocalidadesDelCPFutureProvider` está en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en `LocalidadesListScreen`.

**SDD-UBI-025**
Mientras `getLocalidadesDelCPFutureProvider` está en estado `error`, el sistema deberá mostrar `PaginaSinConeccion` con el mensaje "No se pueden obtener las localidades.".

**SDD-UBI-026**
Mientras `getLocalidadesDelCPFutureProvider` está en estado `data`, el sistema deberá mostrar la lista de localidades generada por `generaLista()`.

**SDD-UBI-027**
Mientras el usuario está en `PaginaBuscaLocalidadGMaps`, el sistema deberá mostrar el campo de CP con `maxLength: 5`, `keyboardType: TextInputType.number` y validator `'Proporciona un código postal'`.

**SDD-UBI-028**
Mientras el usuario está en `PaginaBuscaLocalidadGMaps`, el sistema deberá mostrar la ubicación actual (`addressGM`, `latitud`, `longitud`) y un mapa de Google Maps con `myLocationEnabled: true` y `compassEnabled: true`.

**SDD-UBI-029**
Mientras `valorActualProvider` es 0 en `buildCP`, el sistema deberá establecer `initialValue: null` en el `TextFormField`.

**SDD-UBI-030**
Mientras `valorActualProvider` es mayor a 0, el sistema deberá establecer `initialValue: valorActualProvider.toString()` en el `TextFormField`.

**SDD-UBI-031**
Mientras el usuario esté autenticado y seleccione una localidad ya guardada (`isDuplicate == 200`), el sistema deberá mostrar un `SnackBar` con el mensaje de duplicado y navegar a `principal` después de 3 segundos.

**SDD-UBI-032**
Mientras el usuario esté autenticado y seleccione una localidad nueva (`isDuplicate != 200`), el sistema deberá mostrar el diálogo `openDialogGuardaUserLocal` para confirmar el guardado.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-UBI-030**
Si el usuario presiona "Busca ubicaciones" con el campo de CP vacío, entonces el sistema deberá mostrar el mensaje de error "Proporciona un código postal" y no navegar a la lista de localidades.

**SDD-UBI-031**
Si `fetchLocalidadesCodigoPostal()` retorna un error, entonces el sistema deberá mostrar `PaginaSinConeccion` en `LocalidadesListScreen` y no mostrar la lista.

**SDD-UBI-032**
Si el usuario presiona "Sí, guardar" pero `writeUserLocalidadToCouchDB` falla, entonces el sistema deberá igualmente navegar a `AppRoutes.principal` sin guardar la localidad.

**SDD-UBI-033**
Si `gdtLocalidadUsuario` retorna un código diferente a 200 o 404, entonces el sistema deberá tratar la localidad como nueva y mostrar el diálogo de guardado.

**SDD-UBI-034**
Si el usuario presiona el botón de eliminar pero cierra el diálogo con la barra del sistema (`barrierDismissible: false`), entonces el sistema no debe eliminar la localidad.

**SDD-UBI-035**
Si `codigoPostalBusquedaProvider` es null y `localidadesPorCodigoPostalProvider.codigoPostal` es 0, entonces el sistema deberá establecer `valorActualProvider = 0` y mostrar el campo vacío.

**SDD-UBI-036**
Si el usuario navega a `PaginaBuscaLocalidadGMaps` y el proveedor de ubicación no tiene datos, entonces el sistema debe mostrar valores vacíos o placeholders sin crashear.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-UBI-040**
Donde el usuario tenga localidades guardadas, el sistema deberá mostrar un botón de eliminar (icono `Symbols.delete`) en cada tarjeta de localidad.

**SDD-UBI-041**
Donde el usuario presione una localidad en `LocalidadesListScreen`, el sistema deberá actualizar la sesión global con `updateLocalidadEnSesion(locData.localidadCp)` para que los filtros de búsqueda usen esta localidad.

**SDD-UBI-042**
Donde el usuario esté en `PaginaBuscaLocalidadGMaps`, el sistema deberá mostrar un mapa de Google Maps con la ubicación actual y marcadores, siempre que el proveedor `ubicacionActualProvider` tenga datos válidos.

**SDD-UBI-043**
Donde el usuario guarde una localidad exitosamente, el sistema deberá refrescar la lista de localidades del usuario (`fetchLocalidadesDeUsuario`) para incluir la nueva localidad sin duplicados.

**SDD-UBI-044**
Donde el usuario tenga sesión iniciada, el sistema deberá verificar duplicados mediante `gdtLocalidadUsuario` antes de guardar una localidad.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-UBI-050**
Mientras el usuario esté en `PaginaPrincipalListaLocalidades` sin sesión, cuando presione el botón de login y complete el inicio de sesión, el sistema deberá actualizar el estado de sesión y mostrar el botón de búsqueda de localidades, ocultando el botón de login.

**SDD-UBI-051**
Mientras el usuario esté en `LocalidadesListScreen` con sesión iniciada, cuando seleccione una localidad ya guardada, el sistema deberá mostrar un SnackBar de duplicado y navegar a `principal` después de 3 segundos sin abrir el diálogo de guardado.

**SDD-UBI-052**
Mientras el usuario esté en `LocalidadesListScreen` con sesión iniciada, cuando seleccione una localidad nueva, el sistema deberá mostrar el diálogo de guardado y, al confirmar, guardar en CouchDB, refrescar la lista del usuario y navegar a `principal`.

**SDD-UBI-053**
Mientras el usuario esté en `PaginaBuscaLocalidadGMaps`, cuando ingrese un CP válido y presione "Busca ubicaciones", el sistema deberá validar el formulario, actualizar el provider de localidades, refrescar el future provider y navegar a la lista de localidades del CP.

**SDD-UBI-054**
Mientras el usuario esté en `PaginaPrincipalListaLocalidades` y presione una localidad guardada, el sistema deberá actualizar la sesión con la localidad seleccionada y navegar a `principal` con `pushReplacementNamed`, sin importar si tiene sesión o no.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│              Pantallas de Ubicación                              │
│                                                                 │
│  ┌─────────────────────┐    ┌─────────────────────┐    ┌──────────────────┐  │
│  │PaginaPrincipalLista │    │LocalidadesListScreen│    │PaginaBuscaLocalid│  │
│  │Localidades          │    │(listalocalidades)   │    │adGMaps           │  │
│  │(indexInicial=2)     │    │                     │    │(buscalocalidad)  │  │
│  └──────────┬──────────┘    └──────────┬──────────┘    └──────────┬───────┘  │
│             │                         │                         │          │
│             ▼                         ▼                         ▼          │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │                    Providers de Estado                          │  │
│  │  ┌─────────────────────┐  ┌─────────────────────┐  ┌──────────┐     │  │
│  │  │localidadesPorCodigo │  │userLocalidadesProvid│  │ubicacion │     │  │
│  │  │PostalProvider       │  │er                   │  │ActualProv│     │  │
│  │  │- codigoPostal       │  │- rows[]             │  │ider      │     │  │
│  │  │- localidades        │  │- fetch/save/delete  │  │- address │     │  │
│  │  │- localidadSelecciona│  │                     │  │- lat/lon │     │  │
│  │  └─────────────────────┘  └─────────────────────┘  └──────────┘     │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Acciones:                                                      │
│  - Guardar localidad → CouchDB                                  │
│  - Eliminar localidad → CouchDB                                 │
│  - Buscar por CP → SEPOMEX API                                  │
│  - Navegación a principal con filtros actualizados               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla Principal de Localidades (`PaginaPrincipalListaLocalidades`)

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `scaffoldListaLocalidadesKey` | `pagina_principal_localidades.dart` | `GlobalKey<ScaffoldState>` para control del scaffold |
| Título | `pagina_principal_localidades.dart` | Muestra "{iconoMiLocalidad.etiqueta} seleccionadas" |
| Botón login | `pagina_principal_localidades.dart` | Visible si `userId` vacío; abre `dialogBoxFichaLogin` |
| Botón buscar | `pagina_principal_localidades.dart` | Navega a `AppRoutes.localidades` (`PaginaBuscaLocalidadGMaps`) |
| Lista de localidades | `pagina_principal_localidades.dart` | Muestra cards con `ListTile` (header primario + detalles) |
| Botón eliminar | `pagina_principal_localidades.dart` | Abre `AlertDialog` "Eliminar Ubicación"; confirma con `deleteUserLocalidadFromCouchDB` |
| Navegación a principal | `pagina_principal_localidades.dart` | `updateLocalidadEnSesion` + `pushReplacementNamed` a `AppRoutes.principal` |

### Pantalla Maestra de Localidades (`LocalidadesListScreen`)

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `AppBar` | `screen_maestro_localidades.dart` | Muestra "Localidades del CP {codigoPostal}" |
| `getLocalidadesDelCPFutureProvider` | `screen_maestro_localidades.dart` | `FutureProvider` que carga localidades por CP |
| `generaLista()` | `screen_maestro_localidades.dart` | `ListView.builder` con cards de localidades |
| Card de localidad | `screen_maestro_localidades.dart` | `ListTile` con asentamiento, CP, y flecha de navegación |
| `openDialogGuardaUserLocal` | `screen_maestro_localidades.dart` | Diálogo "Mis Localidades" con botones "No" y "Sí, guardar" |
| Anti-duplicado | `screen_maestro_localidades.dart` | `gdtLocalidadUsuario` retorna 200 si ya existe, 404 si no |
| SnackBar duplicado | `screen_maestro_localidades.dart` | Muestra "'{asentamiento}' ya está en tu lista de localidades." |
| Navegación post-guardado | `screen_maestro_localidades.dart` | `pushReplacementNamed` a `AppRoutes.principal` |

### Pantalla de Búsqueda con Mapa (`PaginaBuscaLocalidadGMaps`)

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `buildCP()` | `pagina_busca_localidades_gmaps.dart` | `TextFormField` con `maxLength: 5`, `keyboardType: number`, validator |
| `_formKeyBuscaUbicacion` | `pagina_busca_localidades_gmaps.dart` | `GlobalKey<FormState>` para validación del formulario |
| Botón "Busca ubicaciones" | `pagina_busca_localidades_gmaps.dart` | Valida, guarda CP, refresca provider, navega a `listalocalidades` |
| `ubicacionActualProvider` | `pagina_busca_localidades_gmaps.dart` | Muestra dirección, latitud, longitud y mapa |
| `GoogleMap` | `pagina_busca_localidades_gmaps.dart` | `myLocationEnabled: true`, `compassEnabled: true`, markers reactivos |
| `onMapCreated` | `pagina_busca_localidades_gmaps.dart` | Llama a `ubicacionActualProvider.notifier.onMapCreated` |
| `valorActualProvider` | `pagina_busca_localidades_gmaps.dart` | Inicializado desde `codigoPostalBusquedaProvider` o `localidadesPorCodigoPostalProvider` |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `ConsumerStatefulWidget` para todas las pantallas de ubicación | Requiere acceso a providers y en algunos casos `setState` para actualizaciones locales |
| DD-02 | `localidadesPorCodigoPostalProvider` como `NotifierProvider` | Necesita métodos personalizados (`setCodigoPostal`, `setLocalidadActual`, `resetLocalidadesCodigoPostal`) |
| DD-03 | `getLocalidadesDelCPFutureProvider` como `FutureProvider` | Encapsula la llamada asíncrona a `fetchLocaliadesCodigoPostal` y maneja estados loading/error/data |
| DD-04 | Diálogo con `barrierDismissible: false` en guardado de localidad | Fuerza decisión explícita del usuario para evitar cierres accidentales |
| DD-05 | Anti-duplicado con `gdtLocalidadUsuario` antes de guardar | Previene registros huérfanos y consultas innecesarias a CouchDB |
| DD-06 | SnackBar de 3 segundos para duplicados | Informa al usuario sin bloquear la navegación |
| DD-07 | `pushReplacementNamed` al navegar a principal desde ubicación | Elimina la pantalla de ubicación del historial, evitando bucles de navegación |
| DD-08 | `Form` + `TextFormField` con validator en búsqueda por CP | Proporciona validación nativa de Flutter y accesibilidad |
| DD-09 | `maxLength: 5` en campo de CP | Limita la entrada a 5 dígitos, estándar de códigos postales mexicanos |
| DD-10 | `ConstrainedBox` con `desktopContentMaxWidth` | Limita ancho en pantallas grandes para mantener legibilidad |
| DD-11 | `SingleChildScrollView` en pantallas de ubicación | Garantiza scroll vertical en móviles donde el contenido puede exceder la pantalla |
| DD-12 | `ubicacionActualProvider` reactivo en mapa | Permite que el mapa se actualice automáticamente cuando cambia la ubicación |
| DD-13 | Tarjetas de localidad con `elevation: 10` | Proporciona profundidad visual consistente con el diseño M3 |
| DD-14 | Botón de eliminar con `IconButton` en header de card | Proporciona acceso rápido a la eliminación sin salir de la lista |
| DD-15 | `ListTile` con `trailing: Symbols.arrow_forward_ios` | Indica navegación disponible de forma consistente con el resto de la app |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
