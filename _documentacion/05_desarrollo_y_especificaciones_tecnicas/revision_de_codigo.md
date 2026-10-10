# Revisión de código — funcionalidad, pantallas y recomendaciones

**Fecha:** 2026-10-07 · **Alcance:** `lib/` (199 archivos `.dart`, 68.875 líneas, de ellas 49.104 activas) y `server/buscobien-mailer/`  
**Método:** lectura de los archivos clave, `flutter analyze`, `flutter test` y búsquedas estáticas con cifras reproducibles. **No** se ejecutó la app en dispositivo ni se probó contra el servidor, por lo que los hallazgos de rendimiento y de comportamiento en tiempo de ejecución son hipótesis a medir.  
**Plan derivado:** [`plan_de_mejoras.md`](../01_planeacion_y_estrategia/plan_de_mejoras.md) (cada hallazgo `H-NN` enlaza a tareas `MEJ-NN`).  
**Seguridad:** el detalle está en [`modelo_de_amenazas.md`](../04_arquitectura_y_diseno/modelo_de_amenazas.md); aquí solo se referencia.

## 1. Resumen

| Dimensión | Estado |
| :--- | :--- |
| Funcionalidad | Los flujos principales existen (catálogo, detalle, listas, red social, publicación). Hay **1 defecto funcional visible** (chat de grupo), funciones documentadas sin cablear y pantallas de marketing con botones inertes |
| Pantallas de despliegue | Completas pero con estados de carga/error repartidos en 81 `FutureBuilder` y 57 `AsyncValue`; accesibilidad casi nula; colores fijos en 32 archivos |
| Pantallas de captura | Funcionan pero con archivos de miles de líneas, sin teclados ni formateadores de entrada y con validación solo por expresión regular en un ayudante propio |
| Calidad técnica | `flutter analyze`: **0 errores, 46 hallazgos** (19 APIs deprecadas, 12 imports sin uso, 7 variables sin uso, 5 bloques de código muerto, 3 imports innecesarios); la única prueba **falla** |
| Mantenibilidad | 30 % de las líneas son comentarios o blancos; ≈10.100 líneas son bloques `/* … */` con código antiguo |

## 2. Inventario de pantallas

### 2.1 Pantallas de despliegue (lectura)
| Grupo | Pantallas (archivo) |
| :--- | :--- |
| Arranque y shell | `splash_page`, `principal_sliver_screen_menus_inicio` (+ `principal_00_inicio`, appbar, menús) |
| Landings por actor (`03_vistas`) | `pagina_usuarios`, `pagina_promotores`, `pagina_propietarios`, `pagina_inmobiliarias`, `pagina_asociaciones`, `pagina_proveedores`, `pagina_market`, `pagina_hospedaje`, `pagina_servicios` |
| Catálogo y detalle | `pagina_inicio_busca_espacios`, `widget_wrap_modern_card`, `pagina_detalle_propiedad`, `google_map_mapa_propiedades` |
| Fotos | `pagina_carousel_fotos_usuario(_mini)`, `pagina_lista_fotos_listado/cuadros/carousel`, `pagina_fotos_menu_opciones` |
| Listas | `pagina_mis_listas`, `pagina_detalle_listas`, `pagina_detalle_lista_compartida` |
| Perfil | `pagina_perfil` |
| Red social | Conocidos: `page_mis_contactos`, `page_descubrir_usuarios`, `page_invitaciones`, `page_perfil_contacto`, `page_chat_privado`. Grupos: `page_mis_grupos`, `page_descubrir_grupos`, `page_invitaciones_grupo`, `page_detalle_grupo` (+ `ChatGrupoEmbebido`) |
| Estado del sistema | `pagina_sin_coneccion`, `pagina_checa_internet`, `pagina_detecta_plataforma`, `pagina_route_error` |

### 2.2 Pantallas de captura (entrada de datos)
| Pantalla | Archivo | Qué captura |
| :--- | :--- | :--- |
| Inicio de sesión | `login_01_login_page`, `dialogbox_login` | Usuario, contraseña, perfil |
| Registro | `login_03_form_register_user` | Datos personales, RFC (promotor), aceptación de términos |
| Recuperación / cambio de contraseña | `page_solicitar_recuperacion`, `page_cambio_password` | Correo y perfil; nueva contraseña |
| Edición de propiedad | `form_update_espacio_comprado` (`Stepper` de 5 pasos) | Propiedad, precio, ubicación, adicionales, contacto |
| Compra de espacios | `form_compra_espacios` | Cantidades, costos, forma de pago |
| Localidades | `pagina_busca_localidades_gmaps` | Código postal / colonia |
| Fotos y avatar | `pagina_agrega_multiples_fotos`, `manejo_imagenes_avatar` | Archivos de imagen |
| Preferencias | `pagina_colores` | Esquema de color |
| Social | Diálogos de crear grupo, aviso (≤250 caracteres), invitar miembros; entrada de chat | Texto |
| Filtros del catálogo | menús superiores de `05_provider_menus` | Tipo, transacción, características |

## 3. Hallazgos

Severidad: **Alta** (defecto visible o bloquea mantenimiento), **Media**, **Baja**.

### 3.1 Funcionalidad

| ID | Hallazgo | Evidencia | Sev. |
| :--- | :--- | :--- | :--- |
| H-01 | **Chat de grupo: todos los mensajes se dibujan como ajenos.** `_BurbujaMensaje` fija `final isMe = false;` y se construye solo con `msg`; el registro de cambios (`versiones.dart:41`) afirma que recibe `currentUserId`. Los 5 avisos `dead_code` de `page_chat_grupo.dart` (líneas 130–184) son consecuencia | `page_chat_grupo.dart:114-124, 109, 349` | **Alta** |
| H-02 | **Landings con botones inertes.** ≈30 manejadores vacíos (`onPressed: () {}`), texto «PROXIMAMENTE REGISTRO» y un formulario «Déjenos sus datos» (inmobiliarias) cuyo botón no envía nada | `03_vistas/pagina_*.dart` | Media |
| H-03 | **Exportar PDF no es accesible.** `PdfGeneratorService` está implementado pero ningún archivo lo invoca | `pagina_detalle_propiedad_pdf.dart` | Media |
| H-04 | **La ficha de propiedad no tiene «Contactar»**; «Compartir» y «Guardar en lista» viven en el carrusel de `22_imagenes`; `fromChatUserId` está declarado y sin uso | `pagina_detalle_propiedad.dart:32`, `pagina_carousel_fotos_usuario.dart:517-585` | Media |
| H-05 | **`PaginaDeError` nunca se muestra:** se crea dentro de una expresión ternaria (permiso de ubicación) sin navegar | `principal_02_page_appbar.dart:120` | Media |
| H-06 | **Faltan operaciones:** eliminar miembro de un grupo, eliminar un contacto, y «alta de propiedad» fuera de la compra de espacios | `GruposNotifier`, `ConocidosNotifier` | Media |
| H-07 | **Recuperación de contraseña por enlace en móvil no puede funcionar aún:** `assetlinks.json` y `apple-app-site-association` tienen valores de ejemplo; en Web solo se evalúa la URL al arrancar | `server/well-known/*`, `deep_link_handler.dart` | Media |
| H-08 | **Rutas:** 16 de 38 constantes sin pantalla y sin `onUnknownRoute` (ruta desconocida devuelve `null`) | `app_routes.dart:251-252` | Baja |
| H-09 | **Archivos sin uso:** `ui_exceptions.dart`, `encriptar.dart` (AES, declarado obsoleto), `genera_cantidad_monetaria.dart`, `pagina_detalle_propiedad_pdf.dart` | referencias por nombre | Baja |

### 3.2 Pantallas de captura

| ID | Hallazgo | Evidencia | Sev. |
| :--- | :--- | :--- | :--- |
| H-10 | **Sin teclado ni formateadores en la captura.** `keyboardType`/`TextInputType` aparece solo en 3 archivos (`pagina_usuarios`, `pagina_busca_localidades_gmaps`, `page_solicitar_recuperacion`); ningún formulario de registro, edición de propiedad o compra lo usa, y no hay `inputFormatters`. Teléfonos, precios y metros se escriben con teclado de texto | búsqueda en `lib/` | Media |
| H-11 | **Validación débil y dispersa.** El `Stepper` de edición usa `AutovalidateMode.disabled`, un solo `TextFormField` y ningún `validator`; la validación se hace con expresiones regulares en `capturaCampoGetConCheckBox`/`renglonCapturaGet`. El resto de formularios sí usa `validator` (registro 2, compra 1, cambio de contraseña 3) | `form_update_espacio_comprado.dart` | Media |
| H-12 | **Archivos gigantes que mezclan UI, estado y HTTP:** `form_update_espacio_comprado` 6.689 líneas (solo 2.045 activas; el resto, versiones antiguas comentadas), `form_crea_ficha_captura_propiedad` 4.692 (3.075 activas), `pagina_lista_fotos_listado` 2.564, `http_funciones_gestion_foto` 1.361 | conteo de líneas | **Alta** |
| H-13 | Tabla de campos por tipo de inmueble escrita en código (`tabla_tipopropiedad_vs_campos.dart`, 30+ listas) | archivo | Baja |
| H-14 | No se encontró *debounce* en búsquedas ni protección contra doble envío en los botones de captura (a confirmar en ejecución) | búsqueda de `debounce`/`Timer` | Baja |
| H-15 | `flutter analyze` no reporta `use_build_context_synchronously`, por lo que el uso de contexto tras `await` y la regla de `if (!mounted) return;` se cumplen en lo que el analizador detecta (una heurística propia dio falsos positivos y se descartó) | `flutter analyze` | Baja |

### 3.3 Pantallas de despliegue (UX, accesibilidad, rendimiento)

| ID | Hallazgo | Evidencia | Sev. |
| :--- | :--- | :--- | :--- |
| H-16 | **Accesibilidad casi nula:** 1 `Semantics`, 0 `semanticLabel`, 54 `tooltip`; no se maneja el escalado de texto (`TextScaler`) | búsqueda en `lib/` | Media |
| H-17 | **Colores fijos contra la regla del proyecto:** 344 usos de `Color(0x…)`/`Colors.*` en 32 archivos (153 `Colors.white`, 73 `Colors.grey`); las landings de `03_vistas` y `form_crea_ficha_captura_propiedad` concentran la mayoría | búsqueda en `lib/` | Media |
| H-18 | **Imágenes:** 25 decodificaciones `base64Decode`, 1 `Image.memory`, 0 `cacheWidth/cacheHeight`; las fotos se piden una por una por id (`recuperaFotoPorIdFoto`) → posible N+1 en listados. A medir en dispositivo | búsqueda en `lib/` | Media |
| H-19 | Mezcla de enfoques de carga: 81 `FutureBuilder` frente a 57 `AsyncValue`/28 `.when(`; los estados de carga/error se resuelven con widgets distintos | búsqueda en `lib/` | Baja |
| H-20 | Solo 2 `RefreshIndicator` en pantallas de lista | búsqueda en `lib/` | Baja |
| H-21 | **APIs deprecadas (19):** `Radio.groupValue/onChanged` en `pagina_colores.dart` (→ `RadioGroup`), `onReorder` en `pagina_lista_fotos_listado.dart` (→ `onReorderItem`). Se romperán al actualizar Flutter | `flutter analyze` | Media |

### 3.4 Calidad técnica y datos

| ID | Hallazgo | Evidencia | Sev. |
| :--- | :--- | :--- | :--- |
| H-22 | **Pruebas:** una sola (plantilla de contador) y falla | `flutter test` | **Alta** |
| H-23 | **Red:** 133 llamadas `http.*`, solo 14 con `.timeout(`; 407 usos de `statusCode` repartidos; sin capa común de errores/reintentos | búsqueda en `lib/` | Media |
| H-24 | **Código muerto:** ≈10.100 líneas en bloques `/* */` con código, 12 imports sin uso, 7 variables sin uso, 5 `dead_code` | `flutter analyze`, conteo | Media |
| H-25 | **Registro:** 1.288 llamadas a `debugPrintLevels`, algunas con argumentos de navegación (T10) | búsqueda | Baja |
| H-27 | **Chat de grupo: las burbujas de propiedad y de lista no se dibujan.** `_BurbujaPropiedad` y `_BurbujaLista` devuelven `SizedBox.shrink()` en `page_chat_grupo.dart`; solo `page_chat_privado.dart` las implementa. El registro de cambios (`versiones.dart`) afirma lo contrario | `page_chat_grupo.dart` | Media |
| H-26 | **Seguridad** (credenciales de CouchDB en el cliente, correo sin autenticación, etc.): ver T1–T13 | modelo de amenazas | **Crítica** (pendiente nginx + JWT) |

## 3.5 Estado tras la Fase 0 (2026-10-07)

| Hallazgo | Estado | Commit |
| :--- | :--- | :--- |
| H-01 chat de grupo (mensajes propios) | **Resuelto** (MEJ-01) | `33a80df` |
| H-22 pruebas | **Parcial:** 9 pruebas verdes (seguridad y rutas); faltan providers, widgets e integración (MEJ-22…25) | `d902d39` |
| H-24 código muerto | **Resuelto en lo medido:** 12 imports y 7 variables eliminados; ≈18.200 líneas de comentarios con código eliminadas (108 bloques `/* */` y 40 líneas `//`). Quedan comentarios descriptivos y líneas `//` sueltas | `d7a9e7d`, `594e138` |
| H-21 APIs deprecadas | **Resuelto** (`RadioGroup`, `onReorderItem`); probar a mano | `4280f6c` |
| H-09 archivos sin uso | Pendiente de decisión (MEJ-06) | — |
| H-27 burbujas del chat de grupo | **Nuevo**, pendiente (MEJ-31) | — |

Métricas actuales: `flutter analyze` = 0 hallazgos; `flutter test` = 9 pruebas verdes; `lib/` = 50.690 líneas (antes 68.875). Los números de línea citados en la documentación se reasignaron al nuevo código.

## 3.6 Estado tras la Fase 1 (2026-10-07)

| Hallazgo | Estado | Commit |
| :--- | :--- | :--- |
| H-02 landings con botones inertes | **Diferido por decisión:** se mantienen como marcadores de posición (roadmap) | — |
| H-03 exportar PDF | **Resuelto** (MEJ-07): botón en el `AppBar` y en la barra de acciones | `764cbfc` |
| H-04 acciones de la ficha | **Resuelto** (MEJ-08): `BarraAccionesPropiedad` (contacto, teléfono, correo, mensaje, guardar, compartir, PDF) | `764cbfc` |
| H-05 `PaginaDeError` | **Resuelto** (MEJ-09): se muestra por permiso de ubicación y por `onUnknownRoute` | `29751ea` |
| H-06 eliminar miembro / contacto | **Resuelto** (MEJ-10) | `f16cba5` |
| H-07 deep links | **Bloqueado** (MEJ-12): faltan `applicationId` definitivo, SHA-256 y `TEAM_ID` | — |
| H-08 rutas muertas | **Resuelto** (MEJ-09): 16 constantes eliminadas | `29751ea` |
| H-27 burbujas del chat de grupo | **Resuelto** (MEJ-31) | `7e3c8ce` |
| **H-28** (nuevo) tras cambiar la contraseña (o con enlace inválido) se navegaba a `/login`, ruta inexistente | **Resuelto**: ahora `/principal` | `29751ea` |
| **H-29** (nuevo) agregar/editar foto desde la lista y el carrusel navegaba a `/fotosagregafotoalista` y `/agregafotopropiedad`, sin pantalla | **Resuelto**: usan `/agregamultiplesfotos` (mismos parámetros); probar a mano | `29751ea` |
| **H-30** (nuevo) `PaginaDetalleWidget` se mostraba sin `Scaffold` (sin botón de regreso ni `Material`) | **Resuelto** en MEJ-08 | `764cbfc` |

Métricas actuales: `flutter analyze` = 0 hallazgos; `flutter test` = 16 pruebas verdes.

## 3.7 Estado tras la Fase 2 (2026-10-09)

| Hallazgo | Estado | Commit |
| :--- | :--- | :--- |
| H-10 / H-11 campos sin teclado ni validación | **Resuelto** (MEJ-13): `CampoTexto` + `Validadores` (`60_global_widgets/campo_texto.dart`) en edición, compra de espacios y registro. **Corrección:** el parámetro `expRegular` del antiguo helper nunca se aplicaba; no había validación por expresión regular | `ff40269`, `809bf50` |
| H-12 formularios gigantes | **Resuelto** (MEJ-14/15): edición 2.175→666 líneas (campos en `edicion/campos_edicion.dart`, acceso en `edicion/acceso_campos.dart`); tarjeta 1.510→722 (+ `ficha_propiedad_dialogos.dart`, `ficha_propiedad_filas.dart`), renombrada a `FichaPropiedadCard` | `ff40269`, `bf6000d` |
| H-14 doble envío | **Parcial** (MEJ-16): guardado de edición y compra protegidos; falta *debounce* en búsquedas | `809bf50` |
| **H-31** (nuevo) el formulario de edición informaba éxito aunque CouchDB fallara | **Resuelto**: se muestra el código de error y no se cierra la pantalla | `ff40269` |
| **H-32** (nuevo) setters de `linkinmobiliaria`/`sloganinmobiliaria` escribían en `inmobiliariaimagen`; faltaban `entrecalle01/02`; el CP se mostraba sin ceros a la izquierda | **Resuelto** y cubierto por prueba de ida y vuelta de los 68 campos | `ff40269` |
| **H-33** (nuevo) el registro rechazaba correos de más de 20 caracteres (límite de la clave aplicado a todos los campos) | **Resuelto**: correo/teléfono validados por tipo; la clave exige 8–20 caracteres | `809bf50` |

Aviso: los nuevos validadores pueden impedir guardar registros antiguos con texto libre en campos numéricos hasta corregirlos (solo el nombre de la propiedad es obligatorio). Probar a mano con datos reales. MEJ-17 (tabla de campos a configuración) sigue como P3.

Métricas actuales: `flutter analyze` = 0 hallazgos; `flutter test` = 29 pruebas verdes.

## 4. Fortalezas observadas

- Estructura modular clara (`NN_modulo`) y nombres consistentes; los 199 archivos están inventariados.
- Uso homogéneo de Riverpod 3 y de modelos inmutables; tema central `appTheme` bien encapsulado.
- Mensajes de error al usuario en los flujos críticos (login, registro, recuperación) y cierre correcto de controladores (`dispose()` 108 veces).
- Disciplina de `mounted` tras `await` cumplida en lo que detecta el analizador.
- Documentación del módulo al día (SDD, Epics, Gherkin, inventarios).

## 5. Cómo se reproducen las cifras

```powershell
flutter analyze          # 0 errores, 46 hallazgos (warning/info)
flutter test             # 1 prueba, falla
python _documentacion/00_indice/verificar_documentacion.py
```
Conteos de líneas y patrones: búsquedas sobre `lib/` (sin comentarios para las «líneas activas»). Cualquier hallazgo debe revalidarse antes de actuar sobre él.
