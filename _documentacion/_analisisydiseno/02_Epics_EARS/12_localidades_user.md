# Epic: Localidades del Usuario (12_localidades_user)

**Directorio:** `lib\12_localidades_user\`  
**Archivos:** `data_user_localidad.dart`, `data_user_localidad_get.dart`, `localidades_repository.dart`, `provider_get_localidades_usuario.dart` (+ `.freezed.dart` generados)  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Ubicación precisa para propiedades y búsquedas | Usuario final | Guarda/edita/elimina sus localidades (CP, calle, sección INE, lat/lon) | CRUD completo localidades usuario |
| | Sistema | Filtra propiedades por localidad del usuario; popula menú nivel gobierno | `localidadesPorCodigoPostalProvider` (consumido por menú gobierno) |

---

## User Story Mapping

```
Usuario en Mi Cuenta → Localidades
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ ClassUserLocalNotifierProvider (Notifier)                   │
│ - fetchLocalidadesDeUsuario(userId)                         │
│ - writeUserLocalidadToCouchDB() (anti-duplicado)            │
│ - deleteUserLocalidadFromCouchDB()                          │
│ - setLocalidadSeleccionada() / addLocalidad2UserLocalidad() │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   LocalidadesRepo   Modelo Freezed    FutureProvider
   - fetchByCP(cp)   UsuarioLocalidades  getUserLocalidades
   - save (anti-dup) (idCp, idUser,     FutureProvider
   - delete          calle, seccionINE,   family
                     lat, lon, timestamp)
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-LOCU-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-LOCU-001 | **Ubicuo** | El sistema definirá `UsuarioLocalidades` (@freezed) con: `idCodigopostal`, `idUsuario`, `pais`, `localidadCp`, `calle`, `seccionine`, `latitud`, `longitud`, `timestamp` — inmutable, `copyWith` generado. | `lib\12_localidades_user\data_user_localidad.dart` | En código |
| REQ-LOCU-002 | **Ubicuo** | El sistema expondrá `ClassUserLocalNotifierProvider` (Notifier) con métodos: `fetchLocalidadesDeUsuario(userId)`, `gdtLocalidadUsuario()`, `writeUserLocalidadToCouchDB()`, `deleteUserLocalidadFromCouchDB()`, `setLocalidadSeleccionada()`, `setUserLocalSelectedFromLocalidades()`, `setUserLocalFromUserLocalGet()`, `resetUsuarioLocalidadesGet()`, `resetlistaLocalidadesUsuario()`, `addLocalidad2UserLocalidad()`. | `lib\12_localidades_user\provider_get_localidades_usuario.dart` | En código |
| REQ-LOCU-003 | **Evento** | Cuando `writeUserLocalidadToCouchDB()` se invoque, el sistema verificará duplicado (mismo `idUsuario` + `localidadCp` + `calle`) antes de guardar en `buscobien_localidades_usuario`. | `localidades_repository.dart:saveUserLocalidad()` | En código |
| REQ-LOCU-004 | **Evento** | Cuando `fetchByCodigoPostal(cp)` se invoque, el sistema consultará vista SEPOMEX en CouchDB (`buscobien_sepomex_localidades`) y retornará localidades para popular menú nivel gobierno. | `localidades_repository.dart:fetchByCodigoPostal()` | En código |
| REQ-LOCU-005 | **Estado** | Mientras `getUserLocalidadesFutureProvider` (FutureProvider.family) esté activo, el sistema proveerá lista reactiva de localidades del usuario para UI (listado, selección, mapa). | `provider_get_localidades_usuario.dart:bottom` | En código |
| REQ-LOCU-006 | **No Deseado** | Si `deleteUserLocalidadFromCouchDB()` falle (network, _rev incorrecto), el sistema propagará excepción sin rollback UI (optimistic update no implementado). | `provider_get_localidades_usuario.dart` | Riesgo |
| REQ-LOCU-007 | **Complejo** | Mientras el usuario edite localidad, cuando `setLocalidadSeleccionada()` actualice estado local, el sistema sincronizará con `setUserLocalFromUserLocalGet()` para mantener consistencia entre modelo local y respuesta GET. | `provider_get_localidades_usuario.dart:60-80` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `UsuarioLocalidades` (@freezed) | `data_user_localidad.dart` | 1-25 |
| `UsuarioLocalidadesGet` / `RowsUserLocal` | `data_user_localidad_get.dart` | 1-30 |
| `LocalidadesRepository` | `localidades_repository.dart` | 1-120 |
| `ClassUserLocalNotifierProvider` | `provider_get_localidades_usuario.dart` | 1-150 |
| `getUserLocalidadesFutureProvider` | `provider_get_localidades_usuario.dart` | 140-150 |

---

## Notas

- **Freezed obligatorio**: `build_runner` genera `.freezed.dart` + `.g.dart` para serialización JSON.
- **Anti-duplicado**: `saveUserLocalidad` hace GET previo antes de PUT — previene duplicados `buscobien_localidades_usuario`.
- **Consumido por**: `appbar_sliver_menu_nivel_gobierno.dart` → `localidadesPorCodigoPostalProvider` (en otro provider) para tabs dinámicos.
- **SEPOMEX**: Datos oficiales México (CP, asentamiento, municipio, estado, lat/lon, sección INE).