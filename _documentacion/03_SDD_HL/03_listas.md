# SDD - 03_listas
**Directorio:** `lib/03_listas`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_mis_listas.dart, provider_user_lists.dart, provider_me_gusta.dart, provider_listas_compartidas.dart, page_compartir_con_conocido.dart, page_compartir_con_grupo.dart, models/*`
- **Providers:** `userListsProvider, listaPropiedadesProvider, listasCompartidasProvider, meGustaProvider`
- **Modelos:** `Lista, GetUserPropertyListModel, Listapropiedad, ListaCompartidaModel, MeGustaModel`
- **Páginas/Rutas:** `/listaspropiedades -> PageMisListas`
- **I/O externo:** CouchDB
- **Dependencias:** http, uuid, flutter_riverpod
- **Riesgos:** Límite duro de 5 contactos al compartir; falta paginación clara en listas grandes.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá permitir crear, consultar y eliminar listas del usuario.

### REQ-EVT-001 — Event-Driven
Cuando el usuario agrega una propiedad a lista, el sistema deberá crear la relación en buscobien_listas_propiedades.

### REQ-EVT-002 — Event-Driven
Cuando el usuario marca “Me gusta” sin lista Favoritas, el sistema deberá crearla automáticamente.

### REQ-STATE-001 — State-Driven
Mientras la lista queda vacía tras eliminar propiedades, el sistema deberá mostrar estado vacío.

### REQ-CMP-001 — Complex
Mientras el usuario comparte, cuando confirma hasta 5 contactos, el sistema deberá persistir registros y notificar destino.

### REQ-UNW-001 — Unwanted
Si la operación de compartir falla, entonces el sistema deberá preservar la lista original y mostrar error.

### REQ-OPT-001 — Optional Feature
Donde el usuario comparta con grupo, el sistema deberá respetar la validación de membrecía.
