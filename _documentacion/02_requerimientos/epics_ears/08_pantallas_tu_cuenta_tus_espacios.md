# Epic: Pantallas — Tus Espacios (Captura y Publicación de Propiedades) (08_pantallas/tu_cuenta/tus_espacios)

**Directorio:** `lib\08_pantallas\tu_cuenta\tus_espacios\`
**Archivos fuente:** 10 `.dart` (6 en raíz + 4 en `compra_espacios/`)
**Total líneas aprox:** ~5.700 en `tus_espacios/` — formulario `form_update_espacio_comprado.dart` 666 líneas, tarjeta `ficha_propiedad_card.dart` 722 (+657 diálogos, +110 filas), `edicion/` 786 y provider `provider_espacios_casa_get.dart` 1.127 líneas. Sigue siendo el módulo de mayor deuda técnica, aunque reducida por MEJ-14/15.
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Promotores capturan y publican propiedades | Promotor / Propietario | Hub central (`PaginaTusEspacios`) de sus propiedades, ficha de cada propiedad (`FichaPropiedadCard`, 722 líneas) y captura/edición con `Stepper` (`PaginaEditaEspacio`, 666 líneas); el alta ocurre al comprar espacios | 2 archivos grandes (tras eliminar el código comentado el 2026-10-07) |
| | Sistema | PUT/POST a CouchDB via Node.js API con tipos de espacio (5 categorías), publicación selectiva | `http_publica_propiedad.dart` (456 líneas) + provider AsyncNotifier de espacios |
| Datos config por tipo inmueble | Sistema (código) | Tabla matriz de campos por tipo (departamento, casa, terreno, etc) — describe qué campos aplican a cada inmueble | `tabla_tipopropiedad_vs_campos.dart` (544 líneas, 30+ `List<String>` const) |
| Sub-feature "comprar/ocurrir un espacio" | Promotor | CRUD `CompraEspacio` (compra ya publicada por otro) | `compra_espacios/` subcarpeta (4 archivos) |

---

## User Story Mapping

```
Sección "Tu Cuenta > Tus Espacios" de PrincipalSliversMenuInicial
   │
   ▼
PaginaTusEspacios (ConsumerStatefulWidget)
   ├── postFrame: inicializa menuTipoEspaciosProvider
   ├── lista EspaciosCasa (provider_espacios_casa_get)
   └── CTAs:
       ├── Ficha de cada propiedad → FichaPropiedadCard (tarjeta; Publicar / Dejar de publicar / Eliminar → http_publica_propiedad)
       ├── Alta → Compra de espacios (genera los espacios; ver REQ-ESP-008)
       ├── Editar → PaginaEditaEspacio (form_update_espacio_comprado, Stepper de 5 pasos)
       └── Comprar/Transferir → compra_espacios/ subcarpeta
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-ESP-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-ESP-001 | **Ubicuo** | El sistema expondrá `PaginaTusEspacios` (ConsumerStatefulWidget, 442 líneas) como hub de "Tus Espacios" (propiedades capturadas por el usuario) — lista con CTAs de alta, edición, compra. | `pagina_tus_espacios.dart:1-438` | En código |
| REQ-ESP-002 | **Estado** | Mientras el usuario esté en `PaginaTusEspacios`, el sistema mantendrá el estado reactivo de su lista de propiedades vía `provider_espacios_casa_get.ClassCompraEspaciosNotifierProvider` (3,865 líneas AsyncNotifier) — filtra `idUsuario == currentUser` y aplica tipoEspacio/nivel. | `provider_espacios_casa_get.dart` | En código |
| REQ-ESP-003 | **Estado** | Mientras se liste una propiedad en `PaginaTusEspacios`, el sistema la dibujará con `FichaPropiedadCard(context, index, valor, callback)` en un `Wrap` de tarjetas de 350 px: foto principal, estado (`PUBLICADA`/`SIN PUBLICAR`), secciones expandibles (Características, Datos del contacto, Datos adicionales) y las acciones Modificar, Publicar, Dejar de publicar y Eliminar. **No hay un formulario de alta separado**: el alta se hace comprando espacios (REQ-ESP-008). | `pagina_tus_espacios.dart:415`, `ficha_propiedad_card.dart` | En código |
| REQ-ESP-004 | **Evento** | Cuando el usuario toque «Modificar» en una propiedad, el sistema navegará a `PaginaEditaEspacio` (`/editaespacio`): `Form` con `Stepper` de 5 pasos (`_buildPasoPropiedad/Precio/Ubicacion/Adicionales/Contacto`) precargado con los datos, para editar y volver a guardar. Cada campo usa `CampoTexto` (teclado, filtro y validación por tipo: entero, dinero, teléfono, correo, URL, CP, latitud/longitud); al guardar se valida todo el formulario y el botón se bloquea mientras se envía; si CouchDB falla se informa el error. | `form_update_espacio_comprado.dart` | En código |
| REQ-ESP-005 | **Ubicuo** | El sistema expondrá `tabla_tipopropiedad_vs_campos.dart` (544 líneas) con 30+ `List<String>` const que describen qué campos aplican a cada tipo de inmueble: recamaras, banos, metrosdeterreno, precioventa, descripción, ubicaciongeneral, etc. | `tabla_tipopropiedad_vs_campos.dart` | En código |
| REQ-ESP-006 | **Evento** | Cuando el usuario submita alta/edición, el sistema invocará `upsertEspacioPublicadoToCouchDB(tipoDeEspacio, datosPropiedadPublicar)` (767 líneas) que POST/PUT a CouchDB (vía Node.js API) con validaciones (fotoprincipal, fechas, endpoint correcto por tipo). | `http_publica_propiedad.dart` | En código |
| REQ-ESP-007 | **Ubicuo** | El sistema expondrá `ListaEspaciosCasa` modelo de estado para `ClassCompraEspaciosNotifierProvider` (no usa Freezed, json serializable dentro del provider). | `provider_espacios_casa_get.dart.ListaEspaciosCasa` | En código |
| REQ-ESP-008 | **Complejo** | Mientras el usuario gestione "compra" de espacios (subcarpeta `compra_espacios/`), el sistema manejará 4 archivos: `data_compra_espacios.dart` (138), `data_compra_espacios_get.dart` (89), `form_compra_espacios.dart` (521), `provider_compra_espacios.dart` (675). | `compra_espacios/` (4 archivos) | En código |
| REQ-ESP-009 | **No Deseado** | Si `ficha_propiedad_card.dart` (722 líneas) y `form_update_espacio_comprado.dart` (666 líneas; antes 6.689, de las cuales ~4.500 eran versiones antiguas comentadas, eliminadas en MEJ-04) siguen mezclando lógica de negocio y UI en una sola clase, el sistema será **difícil de mantener y probar**. | `form_*.dart` | Deuda técnica crítica |
| REQ-ESP-010 | **No Deseado** | Si `tabla_tipopropiedad_vs_campos.dart` (30+ `List<String>` const) está hardcoded, será **caro** añadir/modificar tipos de inmueble o renombrar campos, sin posibilidad de configuración runtime o A/B. | `tabla_tipopropiedad_vs_campos.dart` | Deuda técnica |
| REQ-ESP-011 | **Estado** | Mientras el usuario esté en «Tus Espacios», el sistema mostrará una vista según su tipo: invitado (mensaje «No hay propiedades que mostrar» y dos botones que abren el diálogo de login), usuario normal («Propiedades guardadas [tipo]») o promotor (menú superior de tipo de espacio, botón «Compra de espacios» y su lista de propiedades). | `pagina_tus_espacios.dart`; SDD_tus_espacios §2.1, §3.1–3.3 | En código |
| REQ-ESP-012 | **Estado** | Mientras una propiedad se liste en «Tus Espacios», el sistema mostrará una ficha con tipo, nombre, ubicación, precio y foto principal («Agrega fotos» si no la tiene), el estado `PUBLICADA` (`activa = 1`) o `SIN PUBLICAR` (`activa = 0`) y las acciones Modificar, Publicar / Dejar de publicar y Eliminar; no se podrá eliminar una propiedad activa sin dejar de publicarla. | `ficha_propiedad_card.dart` (tarjeta); SDD_tus_espacios §2.2, §3.6 | En código |
| REQ-ESP-013 | **Evento** | Cuando el usuario edite una propiedad, el sistema mostrará un `Stepper` de 5 pasos (Propiedad, Precio, Ubicación, Adicionales, Contacto) con campos condicionales según el tipo de propiedad y de transacción, validará el formulario al guardar y confirmará con «Se actualizó correctamente». | `form_update_espacio_comprado.dart`; SDD_tus_espacios §2.3 | En código |
| REQ-ESP-014 | **Evento** | Cuando el usuario publique una propiedad, el sistema creará (o actualizará) el documento en la base de publicados correspondiente al tipo de anuncio, pondrá `activa = 1` y guardará el id de publicación en `fotoprincipal`; al dejar de publicar eliminará ese documento y pondrá `activa = 0`. Si la publicación se crea pero falla la actualización de la propiedad, el sistema revertirá la publicación. | `http_publica_propiedad.dart`, `urls_endpoints_espacios.dart`; SDD_tus_espacios §2.4, §6.1 | En código |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla de requerimientos; no hay archivos adicionales que listar.

---

## Deuda Técnica Crítica

1. **`form_update_espacio_comprado.dart` 666 líneas** (antes 2.175; MEJ-14): ahora es declarativo — los 68 campos se describen en `edicion/campos_edicion.dart` (`CampoDef`: tipo, longitud, obligatorio, visibilidad por tipo de inmueble y transacción), el acceso por nombre está en `edicion/acceso_campos.dart` y cada campo se dibuja con `CampoTexto` (teclado, filtro y validación por tipo). Guardado protegido contra doble envío y con resultado real (antes mostraba éxito aunque fallara).
2. **`ficha_propiedad_card.dart` 722 líneas** (antes 1.510; MEJ-15): la tarjeta se partió en `ficha_propiedad_dialogos.dart` (publicar / despublicar / eliminar) y `ficha_propiedad_filas.dart`. Pendiente: mover la lógica de publicar/despublicar a un servicio con prueba unitaria.
3. **`provider_espacios_casa_get.dart` 3,865 líneas**: AsyncNotifier gigante. Debería separarse en N providers (list, filtered list, by type, by nivel, etc.), no en uno con 50 campos.
4. **`tabla_tipopropiedad_vs_campos.dart` hardcoded**: config sin runtime/A/B. Deuda de producto - migrar a provider Riverpod o config CouchDB.
5. **No usa Freezed** para `ListaEspaciosCasa` y `CompraEspacio` — inconsistencia con el resto del proyecto.
6. **`http_publica_propiedad.dart` 456 líneas**: función fat con PUT, POST, manejo 409 conflict, timestamp updates — refactor a N funciones puras.
7. **Sin tests** de ningún archivo. Tested sólo por smoke global — módulo de máxima criticidad sin cobertura.
8. **Acoplamiento transversal**: 22_imagenes (subida fotos), 12_localidades_user (ubicación), 14_geolocalizacion (coords), 40_security (endpoints/espacios), 0_progressive widgets (state, debugprint). Esperado y documentable.
9. **Sub-feature `compra_espacios/` mezclada en mismo módulo** — el "comprar" un espacio no es "tus espacios" propiamente; debería vivir en una sección separada (transferencias / mercado secundario) — deuda de arquitectura.
