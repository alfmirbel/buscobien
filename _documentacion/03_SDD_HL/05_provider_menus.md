# SDD - 05_provider_menus
**Directorio:** `lib/05_provider_menus`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `provider_menu_inicial.dart, provider_menu_principal.dart, provider_menu_nivel_gobierno.dart, provider_menu_tipo_espacio.dart, provider_menu_tipo_de_transaccion.dart, provider_menu_tu_cuenta.dart, appbar_sliver_menu_*.dart, variables_menus.dart`
- **Providers:** `menuInicialProvider, menuPrincipalProvider, menuNivelGobiernoProvider, menuTipoEspacioProvider, menuTipoTransaccionProvider, menuTuCuentaProvider`
- **Modelos:** `MenuOption`
- **Páginas/Rutas:** `Slivers por sección`
- **I/O externo:** No
- **Dependencias:** flutter_riverpod
- **Riesgos:** Reorganización reciente de menús; riesgo de índices huérfanos.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mantener el estado de selección de cada menú sliver.

### REQ-STATE-001 — State-Driven
Mientras indiceInicial == 1, el sistema deberá exponer el menú principal como filtros combinados.

### REQ-CMP-001 — Complex
Mientras el usuario navega por Propiedades, cuando cambie indiceTipoEspacio, el sistema deberá sincronizar menuTipoEspacio y filtrar resultados.

### REQ-UNW-001 — Unwanted
Si un menú secundario queda inconsistente, entonces el sistema deberá restablecer los tabs sin perder filtros activos.
