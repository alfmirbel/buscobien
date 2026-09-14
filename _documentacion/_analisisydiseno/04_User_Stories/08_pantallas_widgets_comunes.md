# User Stories: Widgets Comunes — Etiqueta de Precio por Tipo de Transacción (08_pantallas/widgets_comunes)

### US-WC-001: Mostrar letrero de precio según tipo de transacción

**Card:** Cuando el usuario visualiza una propiedad en el catálogo de inicio
**Conversación:** El desarrollador integra el widget `letrerprecio()` en `WrapModernCardPropiedades`, recibe el objeto `ValueEspaciosCasaGet`, y confirma que el texto cambia según `tipodetransaccion` (Venta, Renta, Venta/Renta, Traspaso).
**Confirmation:** El widget muestra correctamente `"Venta: 1500000 MXN"`, `"Renta: 18000 MXN"`, `"Venta/Renta: 18000/1500000 MXN"`, o `"Traspaso: 1200000 MXN"` dependiendo del tipo; el estilo usa `fontSize:12, fontWeight:bold, color:appTheme.onPrimaryContainer`.

### US-WC-002: Widget `letrerprecio` no contiene lógica de negocio

**Card:** El widget es puro y recibe datos preformateados.
**Conversación:** El programador revisa que `letrerprecio()` sea Stateless y únicamente haga un `switch` sobre `listaSeleccionadas.espacioscasa.tipodetransaccion`; no accede a la base de datos, no persiste nada y no tiene `setState`.
**Confirmation:** El widget compila sin errores y el análisis estático confirma que no hay `setState`, `Future`, ni llamadas HTTP dentro de la función.

### US-WC-003: Tipo de transacción desconocida muestra texto vacío

**Card:** Caso edge para tipos no contemplados.
**Conversación:** El equipo define el case default del switch como `return Text("");` para evitar que el widget rompa el layout si aparece un `tipodetransaccion` inesperado.
**Confirmation:** Al pasarle un `ValueEspaciosCasaGet` con `tipodetransaccion` "Otro", el widget retorna `Text("")` sin excepción ni error de renderizado.

### US-WC-004: Letrero usa colores consistentes con appTheme global

**Card:** El widget respeta el tema global en tiempo de ejecución.
**Conversación:** Al cambiar el tema de `lightPAN` a `darkINE`, el color del texto en el letrero pasa de `appTheme.onPrimaryContainer` claro a `appTheme.onPrimaryContainer` oscuro sin modificar el código del widget.
**Confirmation:** Se verifica inspeccionando en modo oscuro que el color del texto coincide con el ColorScheme oscuro definido en `var_color_themes.dart`.

### US-WC-005: Letrero aparece en todas las cards del catálogo

**Card:** Cobertura del widget en toda la pantalla de inicio.
**Conversación:** El QA revisa visualmente que cada card de la primera página del catálogo (hasta 10 propiedades) incluye el letrero de precio con el tipo correcto y el precio formateado.
**Confirmation:** Se captura screenshot de la pantalla completa y se verifica que no haya cards sin letrero.