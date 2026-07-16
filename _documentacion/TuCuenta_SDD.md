# Software Design Document — Tu Cuenta

**Versión:** 1.0.0 (reverse-engineered)
**Fecha:** 2026-07-12
**Fuente:** Código existente en `/mnt/buscobien/lib/08_pantallas/tu_cuenta`
**Formato:** SDD por feature y subdirectorio
**Scope:** Documento de requerimientos y diseño derivado exclusivamente del código actual. No incluye cambios ni suposiciones fuera del repo.

---

## Índice

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Arquitectura General del Feature](#2-arquitectura-general-del-feature)
3. [Subfeature: Tus Espacios](#3-subfeature-tus-espacios)
4. [Subfeature: Conocidos](#4-subfeature-conocidos)
5. [Subfeature: Grupos](#5-subfeature-grupos)
6. [Trazabilidad por Módulo](#6-trazabilidad-por-m-dulo)
7. [Riesgos](#7-riesgos)
8. [Técnicas de Mitigación](#8-t-cnicas-de-mitigaci-n)
9. [Tipos de Pruebas](#9-tipos-de-pruebas)
10. [Supuestos y Limitaciones](#10-supuestos-y-limitaciones)

---

## 1. Resumen Ejecutivo

El módulo **Tu Cuenta** es el área privada del usuario autenticado dentro de BuscoBien. Agrupa tres dominios diferenciados: gestión de **espacios publicados/comprados**, red social de **conocidos/contactos** y **grupos** comunitarios. Desde aquí el usuario puede administrar sus propiedades, comprar espacios promocionales, invitar/aceptar contactos, chatear y descubrir contenido social. Todo el flujo depende de `sessionProvider`, `menuTipoEspaciosProvider`, proveedores Riverpod y HTTP directo contra CouchDB.

---

## 2. Arquitectura General del Feature

- **Directorio base:** `lib/08_pantallas/tu_cuenta`
- **Subdirectorios:** `tus_espacios`, `conocidos`, `grupos`.
- **Patrón UI:** `ConsumerStatefulWidget` / `StatelessWidget` con `Riverpod` + `Material 3`.
- **Estado:** `NotifierProvider`, `AsyncNotifierProvider`, `StateNotifierProvider`.
- **Storage/sesión:** lectura desde `sessionProvider` + plugins de almacenamiento según SO.
- **Backend:** HTTP básico contra endpoints públicos/privados bajo `direccionip`.

---

## 3. Subfeature: Tus Espacios

**Directorio:** `lib/08_pantallas/tu_cuenta/tus_espacios`

### 3.1 Archivos

- `pagina_tus_espacios.dart`
- `provider_espacios_casa_get.dart`
- `form_crea_ficha_captura_propiedad.dart`
- `form_update_espacio_comprado.dart`
- `http_publica_propiedad.dart`
- `tabla_tipopropiedad_vs_campos.dart`
- `compra_espacios/form_compra_espacios.dart`
- `compra_espacios/provider_compra_espacios.dart`
- `compra_espacios/data_compra_espacios.dart` / `.g.dart`
- `compra_espacios/data_compra_espacios_get.dart`

### 3.2 Modelos relevantes

- `EspaciosCasaGet`, `ValueEspaciosCasaGet`.
- `ListaEspaciosCasa` = índice + propiedades + fotos.
- `CompraEspaciosData` / `GetCompraEspacios`.

### 3.3 Requerimientos y estado

| ID   | Requerimiento                                                         | Evidencia                                                                                           | Estado       |
| ---- | --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------ |
| TE-1 | Listar espacios del usuario autenticado por tipo de menú.             | `getPropiedadesCasaIdUser` usa `menuTipoEspaciosProvider.etiqueta` y endpoints por tipo.            | Implementado |
| TE-2 | Diferenciar vista por perfil: promotor vs usuario normal vs invitado. | `_buildContenidoPrincipal` ramifica por `idUsuario` y `esPromotor`.                                 | Implementado |
| TE-3 | Acceso a compra de espacios desde vista promotor.                     | Navegación a `AppRoutes.compraespacios` desde `_vistaPromotor`.                                     | Implementado |
| TE-4 | Compra de espacios publicitarios con formulario validado.             | `PaginaCompraEspacios` con form + campos normales/destacados/superdestacados/oportunidades/remates. | Implementado |
| TE-5 | Persistencia de compra en CouchDB.                                    | `writeCompraEspaciosToCouchDB` en `compraDeEspaciosProvider`.                                       | Implementado |
| TE-6 | Actualización/edición de espacio comprado.                            | `form_update_espacio_comprado.dart`.                                                                | Implementado |
| TE-7 | Publicación de propiedad desde ficha captura.                         | `http_publica_propiedad.dart` y `form_crea_ficha_captura_propiedad.dart`.                           | Implementado |
| TE-8 | Reset y navegación por índice de espacio.                             | `resetEspaciosCasasGet`, `setIndexEspaciosCasas`, `getEspaciosCasasPropiedadActual`.                | Implementado |
| TE-9 | Mapeo dinámico campos por tipo de propiedad.                          | `tabla_tipopropiedad_vs_campos.dart`.                                                               | Implementado |

---

## 4. Subfeature: Conocidos

**Directorio:** `lib/08_pantallas/tu_cuenta/conocidos`

### 4.1 Archivos

- `conocidos_view.dart`
- `page_mis_contactos.dart`
- `page_invitaciones.dart`
- `page_descubrir_usuarios.dart`
- `page_chat_privado.dart`
- `page_perfil_contacto.dart`
- `mensaje_model.dart`
- `invitacion_model.dart`
- `social_providers.dart`
- `provider_mensajes.dart`
- `models/conocido.dart`, `.freezed.dart`, `.g.dart`
- `providers/conocidos_notifier.dart`

### 4.2 Modelos

- `Conocido`: `id`, `solicitanteId`, `solicitanteNombre`, `receptorId`, `receptorNombre`, `estado`, `fechaActualizacion`.
- `InvitacionEstado`: `pendiente`, `aceptado`, `rechazado`, `bloqueado`.
- `Mensaje`.
- `Invitacion` legado.

### 4.3 Requerimientos y estado

| ID    | Requerimiento                                                        | Evidencia                                                                 | Estado       |
| ----- | -------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------ |
| CN-1  | Navegación principal por tabs: Contactos / Invitaciones / Descubrir. | `ConocidosView` con `NavigationBar`.                                      | Implementado |
| CN-2  | Listar contactos aceptados por usuario.                              | `conocidosAceptadosProvider` filtra lista aceptada.                       | Implementado |
| CN-3  | Iniciar chat privado desde contacto.                                 | `page_chat_privado.dart` navegado desde `PageMisContactos`.               | Implementado |
| CN-4  | Ver perfil de contacto.                                              | `page_perfil_contacto.dart`.                                              | Implementado |
| CN-5  | Enviar invitación a otro usuario.                                    | `ConocidosNotifier.enviarInvitacion` y `page_descubrir_usuarios.dart`.    | Implementado |
| CN-6  | Responder invitación: aceptar/rechazar/bloquear.                     | `ConocidosNotifier.responderInvitacion` actualiza estado en UI optimista. | Implementado |
| CN-7  | Alta directa de contacto aceptado.                                   | `agregarContactoAceptado` para flujos internos sin duplicado.             | Implementado |
| CN-8  | Carga reactiva de invitaciones enviadas/recibidas.                   | `invitacionesRecibidasProvider`, `invitacionesEnviadasProvider`.          | Implementado |
| CN-9  | Descubrir usuarios.                                                  | `PageDescubrirUsuarios`.                                                  | Implementado |
| CN-10 | Persistencia en CouchDB `buscobien_invitaciones`.                    | `_dbInvitaciones` y `_authHeaders` en notifier.                           | Implementado |

---

## 5. Subfeature: Grupos

**Directorio:** `lib/08_pantallas/tu_cuenta/grupos`

### 5.1 Archivos

- `grupos_view.dart`
- `page_mis_grupos.dart`
- `page_invitaciones_grupo.dart`
- `page_descubrir_grupos.dart`
- `page_detalle_grupo.dart`
- `page_chat_grupo.dart`
- `models/grupo_model.dart`, `miembro_grupo_model`, `invitacion_grupo_model.dart`, `publicacion_grupo_model.dart`, `mensaje_grupo_model.dart`, `aviso_grupo_model.dart`, `grupo.freezed.dart`, `grupo.g.dart`
- `providers/grupos_notifier.dart`, `grupos_invitaciones_provider.dart`, `grupos_mensajes_provider.dart`, `publicaciones_grupo_provider.dart`, `avisos_grupo_provider.dart`

### 5.2 Modelos

- `GrupoModel`: `id`, `rev`, `creadorId`, `creadorNombre`, `nombre`, `descripcion`, `objetivo`, `privacidad`, `visibilidad`, `participacion`, `miembros`, `timestamp`.
- `MiembroGrupoModel`: `usuarioId`, `usuarioNombre`, `rol`, `fechaIngreso`.
- `InvitacionGrupoModel`: `senderId`, `senderName`, `receiverId`, `receiverName`, `grupoId`, `grupoNombre`, `status`, `timestamp`, `timestampRespuesta`.
- `PublicacionGrupoModel`, `MensajeGrupoModel`, `AvisoGrupoModel`.

### 5.3 Requerimientos y estado

| ID   | Requerimiento                                                         | Evidencia                                                                                  | Estado       |
| ---- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------ |
| G-1  | Navegación principal por tabs: Mis Grupos / Invitaciones / Descubrir. | `GruposView` con `NavigationBar` y badge de pendientes.                                    | Implementado |
| G-2  | Listar grupos donde el usuario es miembro.                            | `gruposProvider` + `cargarMisGrupos` por `_find` con `$elemMatch` en `miembros.usuarioId`. | Implementado |
| G-3  | Descubrir grupos públicos.                                            | `gruposPublicosProvider` filtra `privacidad: publica`.                                     | Implementado |
| G-4  | Crear grupo con privacidad y participación configurables.             | Dialog en `PageMisGrupos` + `crearGrupo`.                                                  | Implementado |
| G-5  | Agregar miembro a grupo.                                              | `agregarMiembro` con obtención de `_rev` y `GET` previo.                                   | Implementado |
| G-6  | Editar datos del grupo.                                               | `actualizarGrupo` con PUT completo.                                                        | Implementado |
| G-7  | Detalle de grupo.                                                     | `PageDetalleGrupo`.                                                                        | Implementado |
| G-8  | Invitaciones a grupo con badge y respuesta.                           | `gruposInvitacionesProvider`, `fetchInvitaciones`, `invitacionesGrupoRecibidasProvider`.   | Implementado |
| G-9  | Chat grupal.                                                          | `page_chat_grupo.dart`.                                                                    | Implementado |
| G-10 | Publicaciones/avisos dentro de grupo.                                 | `publicaciones_grupo_provider.dart`, `avisos_grupo_provider.dart`.                         | Implementado |
| G-11 | Persistencia en CouchDB `buscobien_grupos`.                           | `_dbGrupos` y endpoints `_find`.                                                           | Implementado |

---

## 6. Trazabilidad por Módulo

| Subfeature                   | Modelos | Providers | Páginas | Estado general |
| ---------------------------- | ------- | --------- | ------- | -------------- |
| tus_espacios/compra_espacios | Parcial | Sí        | Sí      | Completo       |
| tus_espacios                 | Sí      | Sí        | Sí      | Completo       |
| conocidos                    | Sí      | Sí        | Sí      | Completo       |
| grupos                       | Sí      | Sí        | Sí      | Completo       |

---

## 7. Riesgos

- **Alto:** proveedores de mensajes/aviso grupo pueden estar vacíos o solo declarados como placeholders; hay referencias pero no se leyó lógica completa para todos.
- **Alto:** eliminación/edición en CouchDB sigue patrón manual de `_rev` / `_deleted`, con riesgo de conflictos.
- **Medio:** `page_chat_grupo` y `page_chat_privado` dependen de canales temporalmente implícitos sin modelo unificado de mensaje grupo/privado.
- **Medio:** `provider_espacios_casa_get.dart` concentra mucha lógica mixta (CRUD + captura de estado) en una sola clase, dificultando mantenimiento.

---

## 8. Técnicas de Mitigación

| ID   | Técnica de Mitigación                                   | Aplicación en el código                                                                                                                                                              | Categoría           |
| ---- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| M-1  | Revisión y actualización constante de modelos de datos. | Los modelos `Conocido`, `GrupoModel`, `MensajeGrupoModel`, etc., dependen de contratos CouchDB; cualquier cambio de esquema debe reflejarse en `fromJson` / `toJson` y en los tests. | Prevención          |
| M-2  | Control de concurrencia optimista en CouchDB.           | Antes de PUT/POST se obtiene `_rev` y se valida en backend; mitigar conflictos de escritura concurrente con reintentos o UI de “conflicto detectado, actualizar”.                    | Fiabilidad          |
| M-3  | Separación de responsabilidades en providers.           | `provider_espacios_casa_get.dart` concentra CRUD y estado; mitigar refactorizando lógica en repositorios dedicados por operación (listar, crear, actualizar, borrar).                | Mantenibilidad      |
| M-4  | Manejo de errores y estados vacíos en UI.               | Todas las vistas usan `AsyncValue.when` y `FutureBuilder` con estados `loading`, `error`, `data`; ampliar con mensajes claros, botón reintento y logs remotos.                       | UX / Observabilidad |
| M-5  | Seguridad de credenciales.                              | El Basic Auth con `username` / `password` hardcodeados está presente en todos los providers; mitigar moviendo secretos a variables de entorno,证书 pinning y backend proxy auth.     | Seguridad           |
| M-6  | Streaming seguro de mensajes.                           | `_changes` continuo en chat grupo y privado; mitigar reconexión con backoff exponencial, cierre limpio en `dispose` y validación estricta de JSON recibido.                          | Fiabilidad          |
| M-7  | Pruebas unitarias sobre modelos y notifiers.            | Cubrir `fromJson`, `toJson`, filtrados y transformaciones en `ConocidoNotifier`, `GruposNotifier`, `CompraDeEspaciosProvider`.                                                       | Calidad             |
| M-8  | Pruebas de integración contra CouchDB mockeado.         | Usar `http` fake o `mockito` sobre `http.Client` en tests de providers para validar contratos de API sin depender de datos reales.                                                   | Calidad             |
| M-9  | Pruebas de UI y flujos críticos.                        | Usar `flutter_test` + `integration_test` en flujos de compra de espacios, creación de grupo, envío de mensaje y aceptación de invitación.                                            | Calidad             |
| M-10 | Documentación de endpoints y contratos.                 | Centralizar tablas de endpoints (`endpointsCaptura`, `endpointsPublicados`) y documentar en `.contract.md` por feature para mantener trazabilidad.                                   | Trazabilidad        |

---

## 9. Tipos de Pruebas

| ID  | Tipo de Prueba   | Alcance                                                                                                                          | Herramienta sugerida                        |
| --- | ---------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| P-1 | Unitarias        | Modelos (`Conocido`, `GrupoModel`, `InvitacionGrupoModel`), serialización JSON, filtros y helpers.                               | `test` + `freezed` + `json_serializable`    |
| P-2 | Unitarias        | Providers: `conocidos_notifier`, `grupos_notifier`, `compraDeEspaciosProvider`, `mensajesGrupoProvider` con `http.Client` falso. | `mockito` / `http/testing.dart`             |
| P-3 | Widget           | Vistas individuales: `PageMisContactos`, `PageMisGrupos`, `PaginaTusEspacios` en loading/error/empty/data.                       | `flutter_test` + `pumpWidget`               |
| P-4 | Integración      | Flujos completos: compra de espacios, publicación de propiedad, creación de grupo, invitación y chat.                            | `integration_test`                          |
| P-5 | Regresión visual | Snapshot de pantallas clave en M3 para detectar cambios no intencionales.                                                        | `golden_toolkit`                            |
| P-6 | Seguridad        | Validar ausencia de credenciales embebidas en builds release, revisión de endpoints expuestos.                                   | `flutter analyze` + lint custom + SonarQube |
| P-7 | Rendimiento      | Latencia de carga inicial de listas y streaming de chat.                                                                         | DevTools + `flutter_driver` / perfetto      |

---

## 10. Supuestos y Limitaciones

- Este documento cubre exclusivamente el código en `lib/08_pantallas/tu_cuenta` y sus subdirectorios.
- Backend referenciado es CouchDB expuesto al cliente con Basic Auth hardcodeada.
- No se verificó ejecución; todo el análisis es estático.
- Algunos flujos como chat/mensajes/avisos pueden estar declarados pero sin lógica completa si no hay archivo fuente en el listado analizado.
