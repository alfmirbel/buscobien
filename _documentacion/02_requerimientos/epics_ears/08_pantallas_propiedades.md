# Epic: Pantallas — Detalle de Propiedad y Exportación PDF (08_pantallas/propiedades)

**Directorio:** `lib\08_pantallas\propiedades\`
**Archivos fuente:** 3 `.dart` — `data_find_propiedades.dart`, `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`
**Fecha:** 2026-08-13
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Decisión informada de compra/renta | Comprador/Arrendatario | Ve detalle completo de una propiedad: fotos carousel, precio, ubicación, contacto promotor, Me Gusta, "contactar", "compartir" | `PaginaDetalleWidget` (588 líneas) |
| | Sistema | Genera PDF exportable de la ficha técnica | `PdfGeneratorService` (311 líneas) |
| | Negocio | Captura lead mediante CTA contacto al promotor | CTAs en ficha |

---

## User Story Mapping

```
Usuario llega desde catálogo (03_vistas / inicio) o listas (03_listas)
   │
   ▼
PaginaDetalleWidget (ConsumerStatefulWidget)
   ├── initState: fetch `findPropiedades` para idPropiedad
   ├── build():
   │   ├── Carousel fotos completo (PaginaCarouselFotosUsuario de 22_imagenes)
   │   ├── Ficha técnica (precio, ubicación, características)
   │   ├── _FotoItemWidget (miniaturas)
   │   ├── _MeGustaButtonFicha
   │   └── CTAs: Contactar, Compartir (conocido/grupo), Guardar lista, Exportar PDF
   └── onExportPDF: PdfGeneratorService.generate(data) → save/share
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-PROP-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-PROP-001 | **Ubicuo** | El sistema expondrá modelos `FindPropiedades`, `Doc` para tipar la respuesta Mango `$in` bulk de una lista de IDs. | `data_find_propiedades.dart` (58 líneas) | En código |
| REQ-PROP-002 | **Evento** | Cuando el usuario navegue a `PaginaDetalleWidget` con `idPropiedad`, el sistema hará fetch vía `findPropiedades([idPropiedad])` (Mango `$in`) y renderizará Carousel + ficha técnica + CTAs. | `pagina_detalle_propiedad.dart:1-576` | En código |
| REQ-PROP-003 | **Estado** | Mientras el usuario esté en la ficha de detalle, el sistema mantendrá un `_FotoItemWidget` (miniaturas) y un `_MeGustaButtonFicha` (toggle Me Gusta optimistic). | `pagina_detalle_propiedad.dart:_FotoItemWidget`, `_MeGustaButtonFicha` | En código |
| REQ-PROP-004 | **Evento** | Cuando el usuario use la barra de acciones de la ficha (`BarraAccionesPropiedad`), podrá ver los datos de contacto, llamar (solo Android/iOS), escribir un correo o enviar un mensaje al promotor (crea el contacto y envía el mensaje; pide iniciar sesión si no la hay). | `acciones_propiedad.dart` (`mostrarDialogContacto`, `llamarAlPromotor`, `escribirAlPromotor`, `enviarMensajeAlPromotor`) | En código (MEJ-08) |
| REQ-PROP-005 | **Evento** | Cuando el usuario toque «Compartir» en la ficha, el sistema ofrecerá compartir con un conocido o en un grupo y abrirá `PageCompartirConConocido` / `PageCompartirConGrupo` (pide iniciar sesión si no la hay). El carrusel de `22_imagenes` conserva su propio menú. | `acciones_propiedad.dart` (`compartirPropiedad`), `pagina_carousel_fotos_usuario.dart` | En código (MEJ-08) |
| REQ-PROP-006 | **Evento** | Cuando el usuario toque «Guardar» en la ficha, el sistema abrirá `DialogSelectorListas` con el tipo de anuncio de la propiedad (pide iniciar sesión si no la hay). | `acciones_propiedad.dart` (`guardarEnLista`) | En código (MEJ-08) |
| REQ-PROP-007 | **Evento** | Cuando el usuario toque «Exportar PDF» (ícono del `AppBar` o botón «PDF» de la barra de acciones), el sistema mostrará «Generando PDF…», consultará los ids de fotos si la ficha no los trae y llamará `PdfGeneratorService.generarYDescargarPDF`, que arma el PDF carta (imagen, precios, datos, ubicación, contacto, galería de hasta 12 fotos) y lo abre con `Printing.layoutPdf`; si falla, informa el error. | `acciones_propiedad.dart` (`exportarFichaPdf`), `pagina_detalle_propiedad_pdf.dart` | En código (MEJ-07) |
| REQ-PROP-008 | **No Deseado** | Si `findPropiedades` retorna 0 docs (idPropiedad inválido o no encontrado), el sistema mostrará `stateErrorFS` con mensaje "Propiedad no encontrada" y CTA volver. | `FutureBuilderStateWidgets.stateErrorFS` | En código |
| REQ-PROP-009 | **Ubicuo** | El sistema usará el paquete `pdf` (`pub.dev/packages/pdf`) para generar la ficha técnica PDF con imagen, datos y branding Buscobien. | `pagina_detalle_propiedad_pdf.dart` | En código |
| REQ-PROP-010 | **Ubicuo** | El sistema mostrará los datos de la propiedad en un `SingleChildScrollView` con ancho máximo `desktopContentMaxWidth`, márgenes de 15 px en pantallas estrechas y 40 px en anchas, y omitirá los campos vacíos o con valor `"0"` (`valoresVacios = ["", "0"]`). | `pagina_detalle_propiedad.dart:54,68-215`; SDD_08_pantallas_propiedades §2 | En código |
| REQ-PROP-011 | **Estado** | Mientras la ficha se muestre, el sistema cargará la foto principal con `recuperaFotoPorIdFoto` («Sin foto» si no hay id; ícono de imagen rota si falla) y la galería con `recuperaIdsFotosDePropiedades` y `recuperaFotosOrdenadasIdProperty`, usando el orden de los ids como respaldo si el orden guardado no responde 200. | `pagina_detalle_propiedad.dart:352-501`; SDD_08_pantallas_propiedades §3–§5 | En código |
| REQ-PROP-012 | **Ubicuo** | El sistema mostrará las características adicionales (`listamasdatos`) como chips con ícono y texto. | `pagina_detalle_propiedad.dart:208-267`; SDD_08_pantallas_propiedades §4 | En código |
| REQ-PROP-013 | **Ubicuo** | El sistema mostrará la ficha dentro de un `Scaffold` con `AppBar` (clave de la propiedad, botón regresar y exportar PDF) y fondo `appTheme.primaryContainer`; antes se mostraba sin `Scaffold` ni botón de regreso. | `pagina_detalle_propiedad.dart` (`build`) | En código (MEJ-08) |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla de requerimientos; no hay archivos adicionales que listar.

---

## Deuda Técnica

1. **`pagina_detalle_propiedad.dart` 576 líneas** con 2 sub-widgets anidados (`_FotoItemWidget`, `_MeGustaButtonFicha`). Refactor: extraer `_MeGustaButtonFicha` a `60_global_widgets` (es casi idéntica a `_MeGustaButton` de inicio — duplicación latente).
2. **`PdfGeneratorService` 311 líneas**: fat service. Podría parametrizar plantillas de PDF para reusar en otros contextos (ej. reportes, listas).
3. **Acoplamiento con `22_imagenes`** (Carousel), `03_listas` (Compartir, Guardar en lista, Me Gusta provider) y `08_pantallas/tu_cuenta` (mensajes chat). Esperado y documentable.
4. **Sin tests**.
