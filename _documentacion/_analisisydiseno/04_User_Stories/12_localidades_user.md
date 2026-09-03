# User Stories — Localidades del Usuario (12_localidades_user)

**Directorio:** `lib/12_localidades_user/`
**Archivos:** `data_user_localidad.dart`, `data_user_localidad_get.dart`, `localidades_repository.dart`, `provider_get_localidades_usuario.dart` (+ `.freezed.dart` generados) — Total: 4 archivos `.dart`
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-LOCU-001: CRUD Localidades del Usuario con Anti-Duplicado y Consumo SEPOMEX

**Card:**
Como **usuario**
Quiero **guardar, listar y eliminar mis localidades favoritas (CP, calle, sección INE, latitud/longitud)**
Para **filtrar propiedades por mi zona y poblar el menú "Nivel de Gobierno" con tabs dinámicos de mis asentamientos**

**Conversation:**
El subdirectorio implementa un CRUD completo sobre la DB `buscobien_localidades_usuario` vía API Node.js. Modelo de datos: `UsuarioLocalidades` (@freezed) con 9 campos inmutables (`idCodigopostal`, `idUsuario`, `pais`, `localidadCp`, `calle`, `seccionine`, `latitud`, `longitud`, `timestamp`). `ClassUserLocalNotifierProvider` (Notifier @riverpod) expone 10 métodos:
- `fetchLocalidadesDeUsuario(userId)` → GET vista CouchDB, actualiza estado
- `writeUserLocalidadToCouchDB(localidad)` → **anti-duplicado**: GET previo por `idUsuario + localidadCp + calle`, si no existe → POST
- `deleteUserLocalidadFromCouchDB(docId, rev)` → PUT `_deleted=true`
- `fetchByCodigoPostal(cp)` → consulta vista SEPOMEX (`buscobien_sepomex_localidades`) para poblar tabs dinámicos del menú Nivel Gobierno
- `setLocalidadSeleccionada()` + `addLocalidad2UserLocalidad()` + `setUserLocalFromUserLocalGet()` → sincronizan estado local de UI (selección temporal) con modelo GET
- `resetUsuarioLocalidadesGet()` + `resetlistaLocalidadesUsuario()` → limpieza de estado

`LocalidadesRepository` (clase HTTP puro) encapsula las llamadas: `fetchUserLocalidades`, `fetchUserLocalidad`, `saveUserLocalidad` (con anti-dup), `deleteUserLocalidad`, `fetchByCodigoPostal`. `getUserLocalidadesFutureProvider` (FutureProvider.family) provee `Future<List<UsuarioLocalidades>>` reactivo para UI (listado, selección, mapa). El anti-duplicado previene duplicados exactos (mismo usuario + mismo CP + misma calle).

**Confirmation:**
- [ ] `UsuarioLocalidades` (@freezed) tiene 9 campos: `idCodigopostal`, `idUsuario`, `pais`, `localidadCp`, `calle`, `seccionine`, `latitud`, `longitud`, `timestamp`
- [ ] `writeUserLocalidadToCouchDB()` hace GET previo para verificar NO existe `idUsuario + localidadCp + calle`
- [ ] Si NO duplicado → POST a `buscobien_localidades_usuario` con timestamp
- [ ] Si duplicado → retorna sin guardar (no error visible, silencioso)
- [ ] `fetchLocalidadesDeUsuario(userId)` actualiza estado Notifier y `getUserLocalidadesFutureProvider` emite lista
- [ ] `deleteUserLocalidadFromCouchDB(docId, rev)` PUT `_deleted=true` y resetea estado local
- [ ] `fetchByCodigoPostal(cp)` consulta vista SEPOMEX (`buscobien_sepomex_localidades`) y retorna localidades para tabs del menú Nivel Gobierno
- [ ] `setLocalidadSeleccionada()` + `addLocalidad2UserLocalidad()` mantienen estado temporal de selección en UI
- [ ] `setUserLocalFromUserLocalGet()` sincroniza modelo local con respuesta GET
- [ ] `reset...()` limpia estado al navegar fuera
- [ ] `LocalidadesRepository` usa `http` + `dart:convert` (no Dio — HTTP directo)
- [ ] Código requiere `build_runner` para generar `.freezed.dart` y `.g.dart`

---

## US-LOCU-002: Consumo de Localidades por el Menú "Nivel de Gobierno"

**Card:**
Como **usuario filtrando propiedades**
Quiero **que el menú "Nivel de Gobierno" muestre tabs de mis localidades favoritas**
Para **cambiar de zona de búsqueda con un tap sin escribir códigos postales**

**Conversation:**
`appbar_sliver_menu_nivel_gobierno.dart` (en `05_provider_menus`) consume un provider derivado (`localidadesPorCodigoPostalProvider`) que a su vez usa `ClassUserLocalNotifierProvider.fetchByCodigoPostal(cp)`. Cuando el usuario tiene localidades guardadas, el menú "Nivel de Gobierno" se popula dinámicamente con tabs de tipo "Tipo/Localidad" que muestran sus asentamientos. Al tocar una tab, el `homeNavigationProvider.indiceNivelGobierno` se actualiza y la búsqueda de propiedades se filtra por esa localidad. Si no hay localidades guardadas, se muestran los 5 tabs base (Nacional, Estado, Municipio, C.P., Tipo/Localidad — último inactivo).

**Confirmation:**
- [ ] Con localidades guardadas → menú Nivel Gobierno muestra tabs extra "Tipo/Localidad" con nombres de asentamiento
- [ ] Sin localidades guardadas → tabs base (5) sin datos dinámicos
- [ ] Tap en tab dinámica → `homeNavigationProvider.actualizarNivelGobierno(index)` propaga filtro a búsqueda
- [ ] Los tabs usan `ValueKey('menuNivelGobierno-${index}')` (evita error AXTree)
- [ ] La consulta SEPOMEX trae: asentamiento, municipio, estado, lat/lon, sección INE
- [ ] La lat/lon se usa para centrar el mapa si se navega a vista geo
- [ ] Cambios en localidades del usuario (add/delete) → invalidan el provider y reconstruyen tabs

---

## Notas

- Esta US reemplaza a US-LOCU-001 consolidada en `04_User_Stories/03_listas.md` con formato 3 C's completo (Conversation incluida) y añade US-LOCU-002 (consumo por menú).
- Complementa la Epic en `02_Epics_EARS/12_localidades_user.md` y los escenarios Gherkin en `03_Features_BDD/12_localidades_user/localidades_usuario.feature`.
- Para detalles por archivo (4 archivos, 2 tablas): ver `05_Tareas_Inventarios/12_localidades_user/elementos_12_localidades_user.md`.
- El modelo `UsuarioLocalidades` es **inmutable** (@freezed con `copyWith` generado) — toda mutación crea nueva instancia.
- El anti-duplicado usa **GET previo** (no Mango upsert) — 2 llamadas HTTP por intento de guardado (riesgo de race condition si dos instancias concurrentes).
- `fetchByCodigoPostal` consulta `buscobien_sepomex_localidades` (vista SEPOMEX) — datos oficiales México actualizados externamente.