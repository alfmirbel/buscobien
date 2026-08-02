# SDD - 02_principal_screen
**Directorio:** `lib/02_principal_screen`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `principal_00_inicio.dart, principal_02_page_appbar.dart, principal_03_page_drawer.dart, principal_sliver_screen_menus_inicio.dart`
- **Providers:** `sessionProvider, menu*Provider, homeNavigationProvider`
- **Modelos:** `MenuOption`
- **Páginas/Rutas:** `/principal -> PrincipalSliversMenuInicial`
- **I/O externo:** CouchDB indirecto
- **Dependencias:** flutter_riverpod, material_symbols_icons
- **Riesgos:** Drawer con items “Próximamente” sin navegación clara.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá proveer AppBar y Drawer comunes en las secciones principales.

### REQ-UBI-002 — Ubiquitous
El sistema deberá inicializar 7 TabControllers en el shell principal.

### REQ-STATE-001 — State-Driven
Mientras indiceInicial == 0, el sistema deberá mostrar la vista de inicio o la vista sin usuario.

### REQ-STATE-002 — State-Driven
Mientras indiceInicial == 1, el sistema deberá mostrar el menú superior de Propiedades.

### REQ-EVT-001 — Event-Driven
Cuando el usuario presiona “Iniciar sesión” desde la vista sin usuario, el sistema deberá navegar a login.

### REQ-EVT-002 — Event-Driven
Cuando checaConeccionesProvider pierde conexión, el sistema deberá redirigir a /sinconeccion.

### REQ-CMP-001 — Complex
Mientras la app esté en principal, cuando cambie homeNavigationProvider, el sistema deberá hacer scroll al inicio y renderizar la sección activa.

### REQ-UNW-001 — Unwanted
Si Drawer referencia items no implementados, entonces el sistema deberá marcarlos como “Próximamente” sin navegación.

### REQ-OPT-001 — Optional Feature
Donde el usuario sea promotor, el sistema deberá abrir por defecto Tus espacios en Mi Cuenta.
