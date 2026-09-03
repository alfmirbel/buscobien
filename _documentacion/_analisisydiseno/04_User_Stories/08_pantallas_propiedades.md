# User Stories — Pantallas: Detalle de Propiedad + PDF (08_pantallas/propiedades)

**Directorio:** `lib\08_pantallas\propiedades\` (3 archivos `.dart`)
**Epic asociado:** [`02_Epics_EARS/08_pantallas_propiedades.md`](../02_Epics_EARS/08_pantallas_propiedades.md)
**Feature BDD:** [`03_Features_BDD/08_pantallas_propiedades/detalle_propiedad_pdf.feature`](../03_Features_BDD/08_pantallas_propiedades/detalle_propiedad_pdf.feature) (9 escenarios)
**Inventario:** [`05_Tareas_Inventarios/08_pantallas_propiedades/elementos_08_pantallas_propiedades.md`](../05_Tareas_Inventarios/08_pantallas_propiedades/elementos_08_pantallas_propiedades.md)
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## US-PROP-001: Ver detalle completo de una propiedad con carousel y ficha técnica

### Card
**Como** comprador/arrendatario interesado en una propiedad
**Quiero** ver el detalle completo (fotos, precio, ubicación, características, contacto promotor)
**Para** evaluar la propiedad antes de contactar.

### Conversation
- `PaginaDetalleWidget` (`pagina_detalle_propiedad.dart`, 588 líneas, ConsumerStatefulWidget) recibe `idPropiedad` (via ruta/argumento).
- initState dispara `findPropiendas([idPropiedad])` (Mango `$in`) — `data_find_propiedades.dart` modela la respuesta con `FindPropiedades { rows: List<Doc> }`.
- Build del contenido:
  - `PaginaCarouselFotosUsuario` (de `22_imagenes`) en la parte superior con todas las fotos.
  - Ficha técnica: precio (formateado), ubicación (`ubicacioncasa.estado`, `ubicacioncasa.municipio`, `ubicacioncasa.calle`), características (`EspaciosCasa.Datosadicionalescasa` — habitaciones, baños, antigüedad, estacionamiento), datos contacto del promotor (`Datosdelcontactocasa` — teléfono, email).
  - `_FotoItemWidget` (sub-widget): miniaturas inferiores que permiten saltar a una foto específica del carousel.
  - `_MeGustaButtonFicha` (sub-widget): toggle optimistic como `_MeGustaButton` de inicio (basado en `MeGustaNotifier.toggleMeGusta`).
- CTAs inferiores: **Contactar** (abre/crea chat con promotor), **Compartir** (bottom sheet → Conocido/Grupo), **Guardar en lista** (abre `DialogSelectorListas`), **Exportar PDF** (invoca `PdfGeneratorService`).
- **Comentario crítico de deuda:** `_MeGustaButtonFicha` duplica funcionalidad de `_MeGustaButton` de `widget_wrap_modern_card.dart` en inicio. Refactor: extraer a `60_global_widgets/me_gusta_button.dart` para cualquier contexto.

### Conversation — caso vacío
- Si `findPropiedades` retorna `rows=[]` (idPropiedad inválido o eliminado), `FutureBuilderStateWidgets.stateErrorFS("Propiedad no encontrada")` muestra mensaje + CTA "Volver" (`Navigator.pop`).
- Firestore/CouchDB F💾: la propiedad podría existir en DB captura pero no en DB publicados — fallback intermedio sería útil (deuda menor).

### Confirmation
- ✓ Al acceder con un idPropiedad válido, el detalle muestra todas las fotos, ficha técnica y CTAs.
- ✓ Las miniaturas inferiores `_FotoItemWidget` permiten saltar a cualquier foto del carousel.
- ✓ Si la propiedad no existe, se muestra mensaje claro y botón volver.
- ✓ Feature BDD: escenarios "Carga del detalle", "Propiedad no encontrada", "Ver foto principal".

**Trazabilidad:** `REQ-PROP-001`, `REQ-PROP-002`, `REQ-PROP-003`, `REQ-PROP-008` · Archivos: `pagina_detalle_propiedad.dart`, `data_find_propiedades.dart`

---

## US-PROP-002: Contactar al promotor iniciando conversación de chat

### Card
**Como** usuario interesado en una propiedad
**Quiero** un CTA "Contactar" que abra un chat con el promotor para coordinar visita
**Para** hacer follow-up sin exponer mi teléfono hasta que yo quiera.

### Conversation
- CTA "Contactar" en `PaginaDetalleWidget` invoca `mensajesChatProvider` (de `08_pantallas/tu_cuenta/conocidos`) para crear/abrir conversación con el promotor.
- Si la conversación no existe, se crea un doc en `buscobien_mensajes` con `_id = SHA1(userIdOrigen + userIdDestino)`.
- Navega a la pantalla de chat (en `08_pantallas/tu_cuenta/conocidos`).
- Validación de sesión previa: si el usuario no está logueado, redirect a `AppRoutes.login`.
- **Comentario:** el promotor del documento `propiedad:idPropiedad` se obtiene del campo `idusuario` dentro del doc — acoplamiento con `10_user_login`/`usuario_couchdb`.

### Confirmation
- ✓ Al tap "Contactar" con sesión iniciada, abre/crea conversación y navega a chat.
- ✓ Sin sesión, se ofrece login primero.
- ✓ Si la conversación ya existía, abre la existente (no duplica).
- ✓ Feature BDD: escenarios "CTA Contactar al promotor", "Contactar con sesión no iniciada".

**Trazabilidad:** `REQ-PROP-004` · Archivos: `pagina_detalle_propiedad.dart` (CTA), interacciona con `08_pantallas/tu_cuenta/conocidos/mensajesChatProvider`

---

## US-PROP-003: Compartir o guardar la propiedad en una lista

### Card
**Como** usuario
**Quiero** compartir la propiedad con conocidos/grupos o guardarla en una de mis listas
**Para** colaborar o archivar propiedades interesantes.

### Conversation
- CTA "Compartir" despliega un `ModalBottomSheet` con 2 opciones → navega a `PageCompartirConConocido` o `PageCompartirConGrupo` (ambos en `03_listas`).
- CTA "Guardar en lista" abre `DialogSelectorListas` (de `03_listas`) con checkboxes por lista del usuario.
- Tras confirmar las acciones, SnackBars confirmatorios.
- **Comentario:** el detalle actúa como hub de difusión de la propiedad — flujo idéntico al del catálogo de inicio.

### Confirmation
- ✓ CTA "Compartir" abre bottom sheet con Conocido/Grupo.
- ✓ CTA "Guardar en lista" abre el selector con checkboxes.
- ✓ Tras confirmar, SnackBar confirma las acciones completadas.
- ✓ Feature BDD: escenarios "CTA Compartir", "CTA Guardar en lista".

**Trazabilidad:** `REQ-PROP-005`, `REQ-PROP-006` · Archivos: `pagina_detalle_propiedad.dart` (CTAs), `03_listas/page_compartir_con_*`, `03_listas/lista_select_lista_save_propiedad`

---

## US-PROP-004: Generar y compartir PDF de la ficha técnica de la propiedad

### Card
**Como** usuario que quiere archivar o compartir una propiedad offline
**Quiero** un CTA que genere un PDF con foto principal + ficha técnica
**Para** enviarlo por email o guardarlo en mis documentos.

### Conversation
- CTA "Exportar PDF" invoca `PdfGeneratorService.generate(propiedad)` (`pagina_detalle_propiedad_pdf.dart`, 311 líneas).
- El servicio usa el paquete `pdf` (`pub.dev/packages/pdf`) para construir un `Document`:
  - Cabecera con branding Buscobien + logotipo.
  - Foto principal de la propiedad (bytes descargados vía HTTP y embebidos como `PdfImage`).
  - Ficha técnica: precio, ubicación, características (habitaciones, baños, etc), contacto promotor.
  - Footer con fecha de generación y URL del listing.
- Según plataforma:
  - **Móvil**: guarda el PDF en filesystem y ofrece `Share.share` para compartir mediante apps.
  - **Web**: browser trigger download con un `<a download>`.
- **Comentario crítico:** el `PdfGeneratorService` está **acoplado a `EspaciosCasa`** (modelo de inicio) — deuda: parametrizar el generator con una plantilla genérica para que sea reutilizable en otros reportes (ej. listas, fichas de grupos).

### Confirmation
- ✓ Al tap "Exportar PDF", se genera un PDF con imagen + ficha técnica.
- ✓ En móvil, se ofrece compartir o guardar en filesystem.
- ✓ En web, se descarga vía `<a download>`.
- ✓ El PDF tiene branding Buscobien y URL del listing.
- ✓ Feature BDD: escenario "CTA Exportar PDF".

**Trazabilidad:** `REQ-PROP-007`, `REQ-PROP-009` · Archivos: `pagina_detalle_propiedad_pdf.dart`, `data_find_propiedades.dart`

---

## US-PROP-005: Toggle Me Gusta desde la ficha de detalle

### Card
**Como** usuario
**Quiero** un botón "Me Gusta" (corazón) en la ficha de detalle para marcar/desmarcar la propiedad
**Para** reaccionar visualmente y añadir/quitar de mi lista Favoritas.

### Conversation
- `_MeGustaButtonFicha` (sub-widget en `pagina_detalle_propiedad.dart`) es idéntico a `_MeGustaButton` de `widget_wrap_modern_card.dart`.
- Invoca `ref.read(meGustaProvider.notifier).toggleMeGusta(propertyId)` que hace optimistic update + POST/DELETE a `buscobien_megusta_propiedades`.
- Side effect documentado en US-LIST-006 (03_listas): primer me-gusta auto-crea lista "Favoritas".
- **Comentario crítico de deuda:** el código está **duplicado** con `widget_wrap_modern_card._MeGustaButton`. Refactor: extraer a `60_global_widgets/me_gusta_button.dart` reutilizable.

### Confirmation
- ✓ El corazón aparece en la ficha y refleja el estado actual de me-gusta al cargar.
- ✓ Al tap, optimistic visual change + POST en background.
- ✓ Si el POST falla, el corazón revierte.
- ✓ Feature BDD: escenario "Toggle Me Gusta en ficha".

**Trazabilidad:** `REQ-PROP-003` · Archivos: `pagina_detalle_propiedad.dart` (`_MeGustaButtonFicha`), interacciona con `03_listas/provider_me_gusta.dart`

---

## Resumen matriz

| US | Epic Req | Escenarios BDD | Archivos principales |
|----|----------|----------------|----------------------|
| US-PROP-001 (detalle completo) | REQ-PROP-001, 002, 003, 008 | 3 | `pagina_detalle_propiedad.dart`, `data_find_propiedades.dart` |
| US-PROP-002 (contactar promotor) | REQ-PROP-004 | 2 | `pagina_detalle_propiedad.dart` + `08_pantallas/tu_cuenta/conocidos` |
| US-PROP-003 (compartir/guardar) | REQ-PROP-005, 006 | 2 | `pagina_detalle_propiedad.dart` + `03_listas/*` |
| US-PROP-004 (exportar PDF) | REQ-PROP-007, 009 | 1 | `pagina_detalle_propiedad_pdf.dart` |
| US-PROP-005 (Me Gusta en ficha) | REQ-PROP-003 | 1 | `pagina_detalle_propiedad.dart` (`_MeGustaButtonFicha`) |

---

## Notas de deuda técnica

1. **`pagina_detalle_propiedad.dart` 588 líneas** con 2 sub-widgets anidados → refactor: extraer `_FotoItemWidget` y `_MeGustaButtonFicha` fuera del `PaginaDetalleWidgetState`.
2. **`_MeGustaButtonFicha` duplicado con `_MeGustaButton`**: refactor a `60_global_widgets/me_gusta_button.dart` reutilizable.
3. **`PdfGeneratorService` acoplado a `EspaciosCasa`**: parametrizar plantilla para reusar en otros reportes (listas, fichas de grupo).
4. **Sin fallback de DB**: si la propiedad está en `buscobien_casas_comprados_*` pero no en `buscobien_publicados_*`, el detalle no la encuentra. Deuda menor.
5. **`FindPropiedades` no Freezed**: inconsistencia con otros modelos del proyecto.
6. **Acoplamiento transversal esperado** con `22_imagenes`, `03_listas`, `08_pantallas/tu_cuenta/conocidos`. Documentado.
7. **Sin tests**.
