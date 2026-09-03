# Especificación SDD: Pantalla de Detalle de Propiedad Inmobiliaria
**Archivo:** `lib/08_pantallas/propiedades/pagina_detalle_propiedad.dart`

---

## 1. Requerimientos Ubicuos
- El sistema deberá utilizar el esquema de colores `appTheme` definido en Material Design 3 para todos los elementos de la interfaz.
- El sistema deberá presentar la información en un diseño responsivo con anchos máximos controlados (`desktopContentMaxWidth`).
- El sistema deberá aplicar espaciados y márgenes adaptativos según el ancho de pantalla (`isNarrow`).
- El sistema deberá ocultar cualquier campo de dato cuyo valor esté vacío o sea `"0"`.
- El sistema deberá consumir el modelo `ValueEspaciosCasaGet` para acceder a los datos estructurados de la propiedad.

## 2. Requerimientos Controlados por Eventos
- Cuando el usuario acceda al detalle de una propiedad, el sistema deberá renderizar el letrero promocional centrado con fuente `Comfortaa` y estilo bold.
- Cuando el usuario acceda al detalle, el sistema deberá mostrar la descripción, la inmobiliaria, los precios, los datos estructurados, la ubicación, el contacto, las características adicionales y la galería de fotos.
- Cuando el sistema intente cargar la foto principal, deberá mostrar un indicador de espera (`stateWaiting`) mientras la imagen se recupera.
- Cuando la carga de la foto principal falle, el sistema deberá mostrar un mensaje de error de formato (`stateErrorFormat`).
- Cuando no existan fotos para la propiedad, el sistema deberá mostrar el ícono `broken_image` sobre un contenedor `surface`.
- Cuando la foto principal se cargue exitosamente, el sistema deberá mostrarla con borde `outlineVariant` y esquinas redondeadas de 15 px.
- Cuando el usuario presione el botón de favoritos sin sesión activa, el sistema deberá mostrar el diálogo de inicio de sesión (`dialogBoxFichaLogin`).
- Cuando el usuario presione el botón de favoritos con sesión activa, el sistema deberá alternar el estado de "me gusta" y sincronizar la lista del proveedor Riverpod.
- Cuando el sistema detecte que la propiedad ya fue marcada como favorita, deberá mostrar el ícono `favorite` en color rojo de marca (`0xFFE91E63`).
- Cuando el sistema detecte que la propiedad no es favorita, deberá mostrar el ícono `favorite_border`.
- Cuando el usuario solicite generar el PDF, el sistema deberá invocar el servicio de generación de PDF con la propiedad, el ID de foto principal y la lista de IDs de galería.

## 3. Requerimientos Controlados por Estados
- Mientras el sistema se encuentre en el estado de carga de la lista de IDs de fotos (`ConnectionState.waiting`), deberá mostrar el indicador `stateWaiting`.
- Mientras el sistema se encuentre en el estado de error al cargar IDs de fotos, deberá mostrar el mensaje `stateErrorFormat`.
- Mientras no existan datos de IDs de fotos, el sistema deberá mostrar el texto "No se encontraron fotos".
- Mientras se carga el orden de las fotos (`ConnectionState.waiting`), deberá mostrar el indicador `stateWaiting`.
- Mientras se carga una foto individual de la galería (`ConnectionState.waiting`), deberá mostrar el indicador `stateWaiting` de 150x100 px.
- Mientras una foto individual falle al cargar, deberá mostrar el ícono `broken_image` en un contenedor de 150x100 px.
- Mientras el usuario tenga una sesión activa, el botón de favoritos deberá estar habilitado para alternar el estado de "me gusta".

## 4. Requerimientos de Comportamiento No Deseado
- Si la foto principal retorna una cadena base64 vacía, entonces el sistema deberá mostrar el placeholder "Sin foto" centrado.
- Si la recuperación de IDs de fotos de la propiedad retorna una lista vacía, entonces el sistema deberá mostrar el texto "No se encontraron fotos".
- Si el snapshot de fotos ordenadas no tiene datos o su código es distinto de 200, entonces el sistema deberá usar el orden original de la lista de IDs como fallback.
- Si el usuario no ha iniciado sesión, entonces el sistema no deberá agregar la propiedad a favoritos y deberá redirigir al flujo de autenticación.
- Si un dato adicional de la propiedad está vacío, entonces el sistema deberá omitirlo del listado de chips de características.

## 5. Requerimientos de Funciones Opcionales
- Donde el usuario haya iniciado sesión, el sistema deberá exponer el botón de favoritos con tooltip contextual ("Agregar a favoritos" o "Quitar de favoritos").
- Donde la propiedad pertenezca a un chat, el sistema deberá exponer el botón "Guardar en lista" como característica opcional del flujo.

## 6. Requerimientos Complejos
- Mientras el sistema se encuentre en el estado de carga de la galería, cuando el proveedor de fotos ordenadas (`getListaFotosOrdenadasProvider`) tenga datos válidos y no vacíos, el sistema deberá utilizar ese orden para renderizar las fotos; en caso contrario, cuando el proveedor no esté disponible o esté vacío, el sistema deberá usar el orden secuencial de la lista de IDs recuperada del backend.
- Mientras el usuario no tenga sesión activa, cuando presione el botón de favoritos, el sistema deberá interrumpir la acción de toggle y mostrar el diálogo de autenticación.
- Mientras el sistema renderiza la galería con proveedor de orden, cuando una foto falle al cargar individualmente, el sistema deberá mostrar el placeholder de imagen rota sin romper el resto del layout.
