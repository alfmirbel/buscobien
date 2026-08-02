# SDD - 08_pantallas_tu_cuenta
**Directorio:** `lib/08_pantallas/tu_cuenta`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** Vista maestra de Mi Cuenta; delega en subdirectorios
- **Subdirectorios:** `conocidos`, `grupos`, `tus_espacios`, `compra_espacios`
- **Providers:** Por subfeature
- **Modelos:** Por subfeature
- **Páginas/Rutas:** Entrada desde `indiceMiCuenta`
- **I/O externo:** CouchDB HTTP
- **Dependencias:** `flutter_riverpod`, `http`
- **Riesgos:** Routing condicional por perfil; estados huérfanos si subfeature no implementada.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer una sección Mi Cuenta con acceso a subfeatures: espacios, grupos y conocidos.

### REQ-STATE-001 — State-Driven
Mientras el perfil sea promotor, el sistema deberá abrir Tus espacios por defecto en Mi Cuenta.

### REQ-UNW-001 — Unwanted
Si una subfeature no está implementada para el perfil, entonces el sistema deberá mostrar aviso “Próximamente”.

### REQ-CMP-001 — Complex
Mientras el usuario navega Mi Cuenta, cuando cambie indiceMiCuenta, el sistema deberá sincronizar la subpágina activa y preservar scroll.
