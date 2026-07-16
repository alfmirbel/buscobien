# 🔍 Análisis de Código Muerto — Buscobien `lib/`

Metodología: Se verificó cuántos archivos `.dart` distintos referencian (importan o usan) cada archivo. Los archivos con **0 referencias activas** son candidatos a eliminación.

---

## 🔴 CONFIRMADO: 0 referencias — Candidatos a eliminar

Estos archivos no son importados ni usados por ningún otro archivo del proyecto.

### Pantallas / Widgets Obsoletos

| Archivo | Descripción | Motivo de abandono |
|---------|-------------|-------------------|
| [`01_home/home_screen.dart`](file:///d:/buscobien/lib/01_home/home_screen.dart) | Pantalla `HomeScreen` con nav bar, hero section, grids | **Reemplazada** por `PrincipalSliversMenuInicial`. Aparece comentada en `app_routes.dart` (`// const HomeScreen()`) |
| [`01_home/vista_contenido_dinamico.dart`](file:///d:/buscobien/lib/01_home/vista_contenido_dinamico.dart) | Widget `VistaContenidoDinamico` para control de secciones | Sin uso identificado en ningún archivo |
| [`01_splash_screen/splash_view.dart`](file:///d:/buscobien/lib/01_splash_screen/splash_view.dart) | `SplashView` alternativa con lógica auth | **Reemplazada** por `SplashPage` (activa en `app_routes.dart`) |
| [`02_principal_screen/principal_01_page.dart`](file:///d:/buscobien/lib/02_principal_screen/principal_01_page.dart) | `PrincipalPage` con drawer y appbar | **Reemplazada** por `PrincipalSliversMenuInicial`. Aparece comentada (`//return navigateToRoute(const PrincipalPage()`) |
| [`06_notificaciones/pagina_buzon.dart`](file:///d:/buscobien/lib/06_notificaciones/pagina_buzon.dart) | `BuzonPage` con stream de notificaciones | Sin ruta registrada ni import activo |
| [`07_routes/widget_routes_error.dart`](file:///d:/buscobien/lib/07_routes/widget_routes_error.dart) | Widget de error de ruta | Duplicado con `pagina_route_error.dart` |
| [`08_pantallas/ficha_detalle_nota.dart`](file:///d:/buscobien/lib/08_pantallas/ficha_detalle_nota.dart) | Página de detalle de nota | Sin uso ni ruta |
| [`08_pantallas/tu_cuenta/conocidos/page_solicitudes.dart`](file:///d:/buscobien/lib/08_pantallas/tu_cuenta/conocidos/page_solicitudes.dart) | `PageSolicitudes` — vista de solicitudes de contacto | No integrada en `conocidos_view.dart` ni en el router |
| [`08_pantallas/tu_cuenta/grupos/pagina_inicial_grupos.dart`](file:///d:/buscobien/lib/08_pantallas/tu_cuenta/grupos/pagina_inicial_grupos.dart) | `PaginaInicialGrupos` — pantalla anterior del módulo grupos | **Reemplazada** por `page_mis_grupos.dart` (módulo Riverpod) |
| [`08_pantallas/widgets_comunes/dialog_crea_page_in_box.dart`](file:///d:/buscobien/lib/08_pantallas/widgets_comunes/dialog_crea_page_in_box.dart) | Helper `dialogCreaPaginaInsideBox` | Sin uso activo |
| [`08_pantallas/widgets_comunes/encabezado_propiedades.dart`](file:///d:/buscobien/lib/08_pantallas/widgets_comunes/encabezado_propiedades.dart) | Widget `getHeaderPropiedades` | Sin uso activo |

### Listas y Datos Obsoletos

| Archivo | Descripción | Motivo de abandono |
|---------|-------------|-------------------|
| [`03_listas/lista_de_conocidos.dart`](file:///d:/buscobien/lib/03_listas/lista_de_conocidos.dart) | Lista mock de personas (`listaDePersonas`) | Dato de prueba/mock, sin uso |
| [`08_pantallas/propiedades/data_find_id_propiedades.dart`](file:///d:/buscobien/lib/08_pantallas/propiedades/data_find_id_propiedades.dart) | Modelo de búsqueda por ID | Posiblemente reemplazado por otros modelos |
| [`08_pantallas/inicio/http_view_count_registros_propiedades.dart`](file:///d:/buscobien/lib/08_pantallas/inicio/http_view_count_registros_propiedades.dart) | HTTP view counter (sin filtro) | Reemplazado por `http_view_count_filter_propiedades.dart` |
| [`08_pantallas/propiedades/http_get_count_registros_propiedades.dart`](file:///d:/buscobien/lib/08_pantallas/propiedades/http_get_count_registros_propiedades.dart) | HTTP GET para contar registros | Posiblemente duplicado o reemplazado |

### Providers Obsoletos

| Archivo | Descripción | Motivo de abandono |
|---------|-------------|-------------------|
| [`04_provider/captura_propiedad_provider.dart`](file:///d:/buscobien/lib/04_provider/captura_propiedad_provider.dart) | `CapturaPropiedadState` con Freezed | Nuevo provider nunca conectado a UI |
| [`04_provider/provider_01.dart`](file:///d:/buscobien/lib/04_provider/provider_01.dart) | `integerProvider`, `boolProvider` genéricos | Providers huérfanos legacy |
| [`05_provider_menus/provider_menu_tus_contactos.dart`](file:///d:/buscobien/lib/05_provider_menus/provider_menu_tus_contactos.dart) | Provider del menú de contactos | Sin consumidor registrado |
| [`22_imagenes/.../future_get_num_fotos_propiedad.dart`](file:///d:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_fotos_ordenadas/future_get_num_fotos_propiedad.dart) | Future para contar fotos | Sin uso activo |
| [`22_imagenes/.../provider_get_listas_ids_fotos.dart`](file:///d:/buscobien/lib/22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/lista_ids_fotos/provider_get_listas_ids_fotos.dart) | Provider de IDs de fotos | Sin consumidores activos |

### Ubicación — Datos Sepomex Obsoletos

| Archivo | Descripción | Motivo de abandono |
|---------|-------------|-------------------|
| [`08_pantallas/ubicacion/data_sepomex_id.dart`](file:///d:/buscobien/lib/08_pantallas/ubicacion/data_sepomex_id.dart) | Modelo Sepomex por ID | Posiblemente reemplazado por `data_user_localidad` |
| [`08_pantallas/ubicacion/data_sepomex_localidades_get_asenta.dart`](file:///d:/buscobien/lib/08_pantallas/ubicacion/data_sepomex_localidades_get_asenta.dart) | GET localidades por asentamiento | Sin uso activo |
| [`08_pantallas/ubicacion/data_sepomex_localidades_get_id.dart`](file:///d:/buscobien/lib/08_pantallas/ubicacion/data_sepomex_localidades_get_id.dart) | GET localidades por ID | Sin uso activo |
| [`08_pantallas/ubicacion/screen_localidad.dart`](file:///d:/buscobien/lib/08_pantallas/ubicacion/screen_localidad.dart) | Pantalla detalle de localidad | Sin ruta registrada ni import |

### Variables / Utilerías Globales

| Archivo | Descripción | Motivo de abandono |
|---------|-------------|-------------------|
| [`20_var_globales/variables_opciones.dart`](file:///d:/buscobien/lib/20_var_globales/variables_opciones.dart) | Variables `mpOpcion01..12` (opciones de gobierno) | Sin uso en ningún archivo |
| [`40_security/http_interceptor.dart`](file:///d:/buscobien/lib/40_security/http_interceptor.dart) | Cliente HTTP con Dio + interceptores | Nunca integrado; la app usa `http` directo |
| [`60_global_widgets/buttom_con_parametros.dart`](file:///d:/buscobien/lib/60_global_widgets/buttom_con_parametros.dart) | Widget `ButtonConParametros` | Sin uso activo |
| [`60_global_widgets/genera_cantidad_monetaria.dart`](file:///d:/buscobien/lib/60_global_widgets/genera_cantidad_monetaria.dart) | Función `generaCantidad` para montos | Sin uso activo |
| [`60_global_widgets/screen_appbar_header.dart`](file:///d:/buscobien/lib/60_global_widgets/screen_appbar_header.dart) | Helper `appBarHeaderPage` | Sin uso activo |

---

## 🟡 1 Referencia — Revisar manualmente

Estos archivos tienen **exactamente 1 archivo** que los referencia. En la mayoría de los casos son correctos (cada widget usado desde un único padre), pero algunos merecen atención:

### Posibles falsos positivos (uso legítimo de 1 sola referencia):
- `01_home/widgets/` — Los 4 widgets (hero, top_nav, profiles_grid, additional_sections) solo son usados por `home_screen.dart`... **que está sin uso**. Si se elimina `home_screen.dart`, estos 4 también quedan huérfanos.
- `08_pantallas/tu_cuenta/grupos/data_grupos.dart` — Revisar si `grupos_view.dart` realmente lo usa
- `09_forms/form_crea_grupos.dart` — Solo referenciado desde `grupos_view.dart`

> [!NOTE]
> Los 4 widgets en `01_home/widgets/` (`hero_section.dart`, `top_nav_bar.dart`, `profiles_grid_section.dart`, `additional_sections.dart`) dependen exclusivamente de `home_screen.dart`. Si se confirma eliminar `home_screen.dart`, **estos 4 también son código muerto**.

---

## 📊 Resumen

| Categoría | Cantidad |
|-----------|---------|
| Archivos con **0 referencias** (confirmado sin uso) | **29** |
| Widgets derivados huérfanos (`01_home/widgets/`) | **+4** |
| **Total potencial de eliminación** | **~33 archivos** |

---

## ✅ Acción Recomendada

1. **Confirmar con el equipo** que `HomeScreen`, `SplashView` y `PrincipalPage` son definitivamente obsoletos (ya están comentados en el router).
2. **Eliminar en este orden**:
   - Primero: `01_home/home_screen.dart` → luego eliminar `01_home/widgets/`
   - Providers huérfanos: `provider_01.dart`, `captura_propiedad_provider.dart`
   - Pantallas obsoletas de grupos/conocidos
   - Archivos Sepomex sin uso
   - Widgets globales sin consumidores
3. **Ejecutar `flutter analyze`** después de cada eliminación para confirmar que no haya errores.
