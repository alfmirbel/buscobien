# SDD — Módulo `lib/03_vistas` — Especificación de Arquitectura
## Especificación General del Módulo de Landing Pages
**Módulo:** `lib/03_vistas/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_usuarios.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Buscar" (`LandingBusquedaPage`); incluye buscador de Código Postal, carrusel de propiedades destacadas, categorías rápidas y CTAs |
| `pagina_promotores.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Promotores" (`LandingAgentesPage`); incluye hero profesional, estadísticas, grid de herramientas pro y footer CTA |
| `pagina_propietarios.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Propietarios" (`LandingPropietariosPage`); incluye hero, beneficios, pasos, testimonio y CTA final |
| `pagina_hospedaje.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Anfitriones" (`LandingHospedajePage`); incluye hero, beneficios, pasos y CTA |
| `pagina_servicios.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Servicios" (`LandingServiciosPage`); incluye hero, categorías de servicios, propuesta de valor y pasos |
| `pagina_market.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Tienda/Market" (`LandingMarketPage`); incluye hero showroom, categorías de productos, contextual commerce y beneficios retail |
| `pagina_proveedores.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Proveedores" (`LandingProveedoresPage01`); incluye hero, categorías de productos, estrategia "Shop the Look" y herramientas de marketing |
| `pagina_asociaciones.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Asociaciones" (`LandingAsociacionesPage`); incluye hero institucional, grid de aliados, beneficios y eventos |
| `pagina_inmobiliarias.dart` | Fuente — Widget sin Estado (`ConsumerWidget`) | Landing page "Inmobiliarias" (`LandingInmobiliariasPage`); incluye hero enterprise, grid de features, banner API y formulario de contacto |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican a todas las landing pages del módulo en todo momento mientras estén montadas.

**SDD-VIS-001**
El sistema deberá renderizar cada landing page como un `ConsumerWidget` que recibe `WidgetRef ref` para acceder a providers de navegación y estado global.

**SDD-VIS-002**
El sistema deberá utilizar `appTheme` (ColorScheme M3) como fuente única de colores, evitando hardcodear valores hexadecimales excepto para paletas específicas de marca por landing page.

**SDD-VIS-003**
El sistema deberá mantener la navegación hacia la pantalla principal exclusivamente mediante `Navigator.pushReplacementNamed(context, AppRoutes.principal, arguments: "")`, garantizando que el botón atrás no regrese a la landing page.

**SDD-VIS-004**
El sistema deberá sincronizar el estado de navegación global (`homeNavigationProvider`, `menuInicialProvider`, `menuPrincipalProvider`, etc.) antes de cualquier navegación desde una landing page, garantizando que la pantalla principal refleje la sección correcta.

**SDD-VIS-005**
El sistema deberá mostrar el copyright "© 2026 Buscobien. Todos los derechos reservados." en el footer de cada landing page, con color `appTheme.primary` y tamaño de fuente 12.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-VIS-010**
Cuando el usuario abra cualquier landing page, el sistema deberá mostrar una `AppBar` con `backgroundColor: appTheme.primary`, `toolbarHeight: menuToolbarHeight`, `elevation: 0` y `automaticallyImplyLeading: false`.

**SDD-VIS-011**
Cuando se renderice la `AppBar` de cualquier landing page, el sistema deberá mostrar un título que incluye el icono de `menuOpciones[index].icono` y el nombre de la sección en texto blanco, fuente Comfortaa, tamaño 12 y `letterSpacing: 0.5`.

**SDD-VIS-012**
Cuando `ref.watch(homeNavigationProvider).indiceInicial != 0`, el sistema deberá establecer `leading: null` en la `AppBar` para ocultar el botón de regresar.

**SDD-VIS-013**
Cuando `ref.watch(homeNavigationProvider).indiceInicial == 0`, el sistema deberá mostrar un `IconButton` con `Symbols.arrow_back` en el `leading` de la `AppBar` que ejecuta `Navigator.of(context).pop()`.

**SDD-VIS-014**
Cuando el usuario presione el botón de regresar en cualquier landing page con `indiceInicial == 0`, el sistema deberá ejecutar `Navigator.pop()` sin modificar el estado de navegación global.

**SDD-VIS-015**
Cuando el usuario presione el CTA "Iniciar" en la landing page de Promotores, el sistema deberá abrir `dialogBoxFichaLogin` y, si es exitoso, navegar a `AppRoutes.principal` con `indiceInicial=1`, `indicePrincipal=0`.

**SDD-VIS-016**
Cuando el usuario presione "Prueba Gratis" en Promotores, el sistema deberá navegar a `AppRoutes.principal` posicionando los menús en `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0`.

**SDD-VIS-017**
Cuando el usuario presione "Acceder" o "Publicar Gratis Ahora" en Propietarios, el sistema deberá navegar a `AppRoutes.principal` posicionando los menús en `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0`.

**SDD-VIS-018**
Cuando el usuario presione "Inicia" o "Publicar mi Propiedad" en Anfitriones, el sistema deberá navegar a `AppRoutes.principal` posicionando los menús en `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0`.

**SDD-VIS-019**
Cuando el usuario presione el botón "Buscar" en la landing page de Búsqueda, el sistema deberá validar que el código postal capturado tenga entre 4 y 5 dígitos y esté en el rango 1000-99999.

**SDD-VIS-020**
Cuando el Código Postal sea válido en la landing page de Búsqueda, el sistema deberá navegar a `AppRoutes.localidades` con `indiceInicial=1`, `indicePrincipal=4`, `indiceNivelGobierno=0`, `indiceTipoEspacio=0`, `indiceTipoTransaccion=0`.

**SDD-VIS-021**
Cuando el usuario presione cualquier botón etiquetado "PROXIMAMENTE", el sistema deberá mantener la navegación en la misma pantalla sin ejecutar `Navigator.push` ni `Navigator.pushReplacementNamed`.

**SDD-VIS-022**
Cuando el usuario presione "Ver todas" en el carrusel de propiedades de la landing de Búsqueda, el sistema deberá navegar a `AppRoutes.principal` con `indiceInicial=1`, `indicePrincipal=0`, `indiceNivelGobierno=0`, `indiceTipoEspacio=0`.

**SDD-VIS-023**
Cuando se renderice el carrusel de propiedades destacadas en la landing de Búsqueda, el sistema deberá consumir `findPropiedadesEstadosde10en10Provider(paramSkipFind: 0, paramLimitFind: 6)` para obtener 6 propiedades.

**SDD-VIS-024**
Cuando se renderice la landing page de Búsqueda, el sistema deberá mostrar categorías rápidas con íconos: `Symbols.home` (Casas), `Symbols.apartment` (Depas), `Symbols.storefront` (Locales), `Symbols.landscape` (Terrenos).

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-VIS-020**
Mientras se renderiza la sección Hero de cualquier landing page, el sistema deberá mostrar una imagen de fondo desde `menuOpciones[index].imagePath` con `BoxFit.cover` y un `ColorFilter.mode` oscuro (`BlendMode.darken`, `alpha: 0.85-0.9`) para legibilidad del texto.

**SDD-VIS-021**
Mientras el usuario esté en la landing page de Promotores, el sistema deberá mostrar un grid de herramientas con `GridView.count` y `crossAxisCount` adaptable: 1 columna en móvil, 2 en tablet (`smallScreenMin` a `smallScreenMax`), 3 en desktop pequeño (`mediumScreenMin` a `mediumScreenMax`) y 4 en pantallas grandes (`>= largeScreenMin`).

**SDD-VIS-022**
Mientras el usuario esté en la landing page de Búsqueda, el sistema deberá mostrar un `TextField` con `keyboardType: TextInputType.number`, `FilteringTextInputFormatter.digitsOnly` y `LengthLimitingTextInputFormatter(5)`.

**SDD-VIS-023**
Mientras el usuario esté en la landing page de Búsqueda, el sistema deberá mostrar un carrusel horizontal (`ListView.separated` con `scrollDirection: Axis.horizontal`) de 6 propiedades con `widthCuadroFotoPropiedadLocal` y `heightCuadroFotoPropiedadLocal + 40`.

**SDD-VIS-024**
Mientras el usuario esté en la landing page de Propietarios, el sistema deberá mostrar una sección de pasos numerados (1, 2, 3) con íconos `Symbols.person_add_alt`, `Symbols.add_a_photo`, `Symbols.chat_bubble_outline` y líneas conectoras grises.

**SDD-VIS-025**
Mientras el usuario esté en la landing page de Servicios, el sistema deberá mostrar tarjetas de servicios con `CircleAvatar` de radio 25, ícono centrado y texto de título y subtítulo.

**SDD-VIS-026**
Mientras el usuario esté en la landing page de Proveedores, el sistema deberá mostrar una sección de estrategia con imagen y etiquetas de compra superpuestas (`_shoppingTag`) en posiciones absolutas.

**SDD-VIS-027**
Mientras el usuario esté en la landing page de Asociaciones, el sistema deberá mostrar logos de asociaciones en `Container` circulares de 80x80 con `boxShadow` y texto centrado en fuente negrita.

**SDD-VIS-028**
Mientras el usuario esté en la landing page de Inmobiliarias, el sistema deberá mostrar un grid de beneficios con `GridView.count` y `crossAxisCount` adaptable (1 o 3 columnas según `constraints.maxWidth > 800`).

**SDD-VIS-029**
Mientras se renderice cualquier landing page, el sistema deberá envolver el contenido en `SingleChildScrollView` para permitir scroll vertical en dispositivos móviles.

**SDD-VIS-030**
Mientras el usuario esté en la landing page de Búsqueda, el sistema deberá mostrar el texto "Propiedades Sobresalientes" con botón "Ver todas" que navega a la sección de propiedades.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-VIS-030**
Si el código postal ingresado en la landing de Búsqueda es menor a 1000 o mayor a 99999, entonces el sistema deberá mostrar un `SnackBar` con el texto "Por favor captura un CP válido de 5 dígitos." en color `appTheme.error`.

**SDD-VIS-031**
Si el código postal tiene menos de 4 dígitos o más de 5, entonces el sistema deberá mostrar un `SnackBar` con el texto "El Código Postal debe ser de 5 dígitos." en color `appTheme.error`.

**SDD-VIS-032**
Si el usuario presiona un botón CTA con `onPressed: () {}` (vacío), entonces el sistema no debe ejecutar navegación ni mostrar errores, manteniendo la landing page visible.

**SDD-VIS-033**
Si `findPropiedadesEstadosde10en10Provider` retorna `error`, entonces el sistema deberá mostrar el texto "Error: No se pudieron cargar datos.\n$err" centrado en el carrusel.

**SDD-VIS-034**
Si `findPropiedadesEstadosde10en10Provider` retorna `data` con `rows.isEmpty`, entonces el sistema deberá mostrar el texto "No hay propiedades destacadas." centrado.

**SDD-VIS-035**
Si el usuario intenta navegar a una landing page sin `menuOpciones[index]` definido, entonces el sistema deberá fallback a valores por defecto o mostrar una pantalla vacía sin crashear.

**SDD-VIS-036**
Si la imagen de fondo especificada en `menuOpciones[index].imagePath` no existe en los assets, entonces el sistema deberá mostrar un contenedor sólido del color de fallback sin interrumpir la renderización.

**SDD-VIS-037**
Si el usuario presiona el botón "Compartir" en una tarjeta de lista sin conocidos (`conocidosAceptadosProvider` vacío), entonces el botón debe estar deshabilitado (`onPressed: null`) y no debe abrir el diálogo de compartir.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-VIS-040**
Donde la landing page de Búsqueda incluya el carrusel de propiedades, el sistema deberá consumir `findPropiedadesEstadosde10en10Provider` con `paramLimitFind: 6` para obtener exactamente 6 propiedades destacadas.

**SDD-VIS-041**
Donde la landing page de Promotores incluya el grid de herramientas, el sistema deberá utilizar `LayoutBuilder` para adaptar `crossAxisCount` y `aspect` según breakpoints: `xSmallScreenMax/2`, `xSmallScreenMax`, `smallScreenMin`, `mediumScreenMin`, `largeScreenMin`.

**SDD-VIS-042**
Donde la landing page de Búsqueda incluya el campo de Código Postal, el sistema deberá utilizar `codigoPostalBusquedaProvider` para almacenar el valor numérico en tiempo real.

**SDD-VIS-043**
Donde la landing page de Propietarios incluya el testimonio, el sistema deberá mostrar un texto entre comillas con autor, usando `Symbols.format_quote` como ícono decorativo.

**SDD-VIS-044**
Donde la landing page de Proveedores incluya la estrategia "Shop the Look", el sistema deberá renderizar etiquetas de compra superpuestas (`_shoppingTag`) en coordenadas absolutas dentro de un `Stack`.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-VIS-050**
Mientras el usuario esté en cualquier landing page, cuando presione un CTA de navegación a la app principal, el sistema deberá sincronizar múltiples providers de menú (`menuInicialProvider`, `menuPrincipalProvider`, `menuNivelDeGobiernoProvider`, `menuTipoEspaciosProvider`, `menuTipoDeTransaccionProvider`) y luego ejecutar `Navigator.pushReplacementNamed` hacia `AppRoutes.principal`.

**SDD-VIS-051**
Mientras el usuario esté en la landing page de Búsqueda, cuando ingrese un código postal válido y presione "Buscar", el sistema deberá validar el rango (1000-99999), sincronizar 5 providers de menú con índices específicos y navegar a `AppRoutes.localidades`.

**SDD-VIS-052**
Mientras el usuario esté en la landing page de Promotores y presione "Iniciar", cuando `dialogBoxFichaLogin` retorne `true`, el sistema deberá navegar a `AppRoutes.principal` con `indiceInicial=3` (Mi Cuenta); cuando retorne `false`, deberá navegar con `indiceInicial=1` (Propiedades).

**SDD-VIS-053**
Mientras el usuario esté en la landing page de Búsqueda y el `LayoutBuilder` detecte `constraints.maxWidth > smallScreenMin`, cuando se renderice el grid de herramientas o beneficios, el sistema deberá aumentar `crossAxisCount` y ajustar `aspect` y tamaños de fuente para pantallas anchas.

**SDD-VIS-054**
Mientras el usuario esté en la landing page de Proveedores, cuando renderice la sección de estrategia, el sistema deberá mostrar una imagen de fondo con etiquetas superpuestas de productos (`_shoppingTag`) y texto explicativo de publicidad contextual en un layout de dos columnas.

**SDD-VIS-055**
Mientras el usuario esté en cualquier landing page con `SingleChildScrollView`, cuando haga scroll hacia el footer, el sistema deberá mantener la AppBar fija en la parte superior y mostrar el contenido del footer al final del scroll sin superponerse.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    LandingPage (ConsumerWidget)                 │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ AppBar      │    │  Hero/Hero   │    │  Content Sections│  │
│  │             │    │  Section     │    │                  │  │
│  │ - Título    │    │              │    │ - Grid benefits  │  │
│  │ - Icono     │    │ - Imagen     │    │ - Carrusel       │  │
│  │ - Regresar  │    │   fondo      │    │ - Pasos          │  │
│  │   condicional│   │ - Gradiente  │    │ - Testimonios    │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     menuOpciones[index]        │
              │  ┌─────────────────────────┐  │
              │  │ nombreCorto: String     │  │
              │  │ icono: IconData         │  │
              │  │ imagePath: String       │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │homeNavigat.Prov│ │sessionProv │ │Providers    │
      │indiceInicial  │ │            │ │Específicos  │
      │indicePrincipal│ │            │ │             │
      └─────────────┘ └─────────────┘ └─────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Navegación a Principal     │
              │  ┌─────────────────────────┐  │
              │  │ pushReplacementNamed   │  │
              │  │ (AppRoutes.principal)  │  │
              │  │                        │  │
              │  │ Sincroniza:            │  │
              │  │ - menuInicial          │  │
              │  │ - menuPrincipal        │  │
              │  │ - nivelGobierno        │  │
              │  │ - tipoEspacio          │  │
              │  │ - tipoTransaccion      │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Estructura Común

| Elemento | Archivo(s) | Comportamiento |
|---|---|---|
| `AppBar` | Todas | `backgroundColor: appTheme.primary`, `toolbarHeight: menuToolbarHeight`, `elevation: 0`, `automaticallyImplyLeading: false` |
| `leading` condicional | Todas | `IconButton` con `Symbols.arrow_back` si `indiceInicial == 0`, `null` en caso contrario |
| `title` | Todas | `Row` con `Icon(menuOpciones[index].icono)` + `Text` con nombre de sección |
| Hero section | Todas | `Container` con `DecorationImage` desde `menuOpciones[index].imagePath` + `ColorFilter` oscuro |
| Footer | Todas | Texto copyright o `derechosReservadosObscuro()` |

### Landing Page Búsqueda (`pagina_usuarios.dart`)

| Elemento | Comportamiento |
|---|---|
| Buscador CP | `TextField` numérico, max 5 dígitos, `codigoPostalBusquedaProvider` |
| Validación CP | Rango 1000-99999, SnackBar error si es inválido |
| CTA "Publicar" | Navega a `principal` con `indiceInicial=1`, `indicePrincipal=0` |
| CTA "Iniciar" | Navega a `principal` con reset completo de menús |
| Carrusel | `findPropiedadesEstadosde10en10Provider` con 6 propiedades, scroll horizontal |
| Categorías | 4 íconos: Casas, Depas, Locales, Terrenos |
| Botón "Ver todas" | Navega a `principal` con `indiceInicial=1`, `indicePrincipal=0` |

### Landing Page Promotores (`pagina_promotores.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero profesional | Altura 500, imagen de fondo, badge "Servicio para Promotores Inmobiliarios" |
| Estadísticas | 3 columnas: Vistas, Precio, Multiplataforma |
| Grid herramientas | 5 tools: Analítica, Gestión Leads, Posicionamiento, Perfil Verificado, API & XML |
| CTA "Prueba Gratis" | Navega a `principal` con `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0` |
| CTA "Iniciar" | Abre login, luego a `indiceInicial=1`, `indicePrincipal=0` |

### Landing Page Propietarios (`pagina_propietarios.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Altura 500, badge "Sin intermediarios obligatorios", CTA "Publicar Gratis Ahora" |
| Stats | +50k Compradores, 100% Control Tuyo, 24/7 Visibilidad |
| Beneficios | 4 cards: Ahorra Comisiones, Panel de Control, Busca Promotores, Seguridad de Datos |
| Pasos | 3 pasos: Crea cuenta, Sube fotos, Recibe interesados |
| Testimonio | Card naranja con ícono `Symbols.format_quote` y autor |
| CTA "Acceder" | Navega a `principal` con `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0` |

### Landing Page Anfitriones (`pagina_hospedaje.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Altura 500, badge "RENTA POR DÍAS O SEMANAS", CTA "Publicar mi Propiedad" |
| Beneficios | Huéspedes Verificados, Control Total, Pagos Seguros |
| Pasos | 4 pasos: Publica anuncio, Recibe reservaciones, Recibe huéspedes, Recibe pago |
| CTA "Inicia" | Navega a `principal` con `indiceInicial=1`, `indicePrincipal=5`, `indiceMiCuenta=0`, `indiceTipoEspacio=0` |

### Landing Page Servicios (`pagina_servicios.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Badge "PROXIMAMENTE", CTA "OFRECER MIS SERVICIOS" (sin acción) |
| Categorías | Mudanzas, Remodelación, Interiorismo, Mantenimiento, Carpintería, Limpieza |
| Valor | Oferta directa vs Leads Calificados |
| Pasos | 3 pasos: Crea perfil, Define zona, Recibe alertas |

### Landing Page Tienda/Market (`pagina_market.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Badge "PROXIMAMENTE", CTA "AQUÍ PODRAS SUBIR TÚ CATÁLOGO" (sin acción) |
| Categorías | Mobiliario, Materiales, Electrodomésticos, Smart Home |
| Contextual | Cards: "Si el usuario ve una Cocina... mostramos tu Refrigerador" |
| Beneficios | Contacto Directo, Promociones Digitales, Visualización |

### Landing Page Proveedores (`pagina_proveedores.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Badge "PROXIMAMENTE PARA TIENDAS Y FABRICANTES", CTA "PROXIMAMENTE SUBIR MI CATÁLOGO" |
| Categorías | Chips: Muebles, Iluminación, Pisos y Baños, Domótica, Electrodomésticos, Seguridad, Decoración, Materiales |
| Estrategia | Imagen con `_shoppingTag` superpuestos (`$ Sofa`, `$ Lámpara`) |
| Marketing | Links, Oferta, Información |

### Landing Page Asociaciones (`pagina_asociaciones.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Badge "PROXIMAMENTE", ícono `Symbols.balance`, CTA "Proximamente Registro de Asociaciones" |
| Aliados | AMPI (verde), APCI (azul), UPIM (naranja), MIO (rojo), SUMA (morado) |
| Beneficios | Membresía, Difusión de Eventos, Bolsa Inmobiliaria |
| Eventos | Cards horizontales: Foros 2026, Desayuno Networking, Certificación EC0110, Congreso Nacional |

### Landing Page Inmobiliarias (`pagina_inmobiliarias.dart`)

| Elemento | Comportamiento |
|---|---|
| Hero | Badge "PROXIMAMENTE PARA AGENCIAS Y DESARROLLADORAS", CTA "PROXIMAMENTE REGISTRO" |
| Features | Gestión de Agentes, Micrositio, Carga Masiva |
| Contacto | Formulario simulado con botón "PROXIMAMENTE REGISTRO CORPORATIVO" |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Todas las landing pages usan `ConsumerWidget` sin estado | Las landing pages son mayormente informativas; no requieren gestión de estado local compleja |
| DD-02 | `AppBar` con `automaticallyImplyLeading: false` | Permite control total sobre el botón de regresar según `indiceInicial` |
| DD-03 | Botón de regresar solo visible en `indiceInicial == 0` | El usuario debe poder regresar al menú de inicio solo si vino desde ahí |
| DD-04 | Navegación con `pushReplacementNamed` a `principal` | Elimina la landing page del historial; el usuario no puede regresar con el botón atrás |
| DD-05 | Paletas de color específicas por landing page | Cada landing page tiene identidad visual propia: Promotores (dorado), Propietarios (rojo), Servicios (turquesa), etc. |
| DD-06 | `menuOpciones[index].imagePath` como imagen de fondo | Centraliza la configuración de imágenes en un solo archivo (`00_principales_opciones.dart`) |
| DD-07 | `ColorFilter.mode(..., BlendMode.darken)` en imágenes de fondo | Asegura legibilidad del texto blanco sobre cualquier imagen |
| DD-08 | CTAs "PROXIMAMENTE" con `onPressed: () {}` | Marca funcionalidades futuras sin bloquear la UI ni mostrar errores |
| DD-09 | Carrusel con `findPropiedadesEstadosde10en10Provider` limit: 6 | Limita la carga inicial a 6 propiedades para optimizar rendimiento |
| DD-10 | `LayoutBuilder` en grids adaptativos | Permite breakpoints responsivos sin dependencias externas |
| DD-11 | `SingleChildScrollView` en todas las landing pages | Garantiza scroll vertical en móviles donde el contenido puede exceder la pantalla |
| DD-12 | Botones de AppBar con `TextButton` o `ElevatedButton` segun contexto | Botones secundarios usan `TextButton`, CTAs principales usan `ElevatedButton` |
| DD-13 | Footer con copyright estático o `derechosReservadosObscuro()` | Mantiene consistencia de marca en todas las landing pages |
| DD-14 | Sincronización de 5 providers antes de navegar a principal | Garantiza que la pantalla principal abra con los filtros correctos según el CTA presionado |
| DD-15 | `dialogBoxFichaLogin` en landing de Promotores | Permite login inline antes de navegar a la app principal |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
