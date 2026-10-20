# Plan de trabajo: Lanzamiento del MVP de BuscoBien

> **Tipo:** plan de trabajo (propuesta para revisión). **Fecha:** 2026-10-19.
> **Versión 2 (2026-10-19):** incorpora las decisiones del propietario sobre L2, L4, L6, L12–L13, L21 y L22 (sección 3.1).
> **Fuente:** `_planes/Estrategia_Integral_de_Lanzamiento_MVP.md` (en adelante, «la estrategia»).
> **Contrastado con:** el código de `lib/` y de `D:\buscobien-api`, `_documentacion/` y el plan `Hermes_Real_Estate_Core_Plan_Integracion_Mi_Asistente_IA.md`. La sección 2 separa lo que ya existe de lo que falta.
> **Este plan no modificó código ni documentación.** Los archivos y endpoints que menciona son los previstos para la implementación.

## Contenido

1. Resumen ejecutivo
2. Requerimientos de la estrategia frente al estado real
3. Decisiones
4. Diseño de la solución
5. Plan por fases
6. Pruebas y calidad
7. Documentación SDLC a actualizar
8. Riesgos y mitigaciones
9. Indicadores del lanzamiento
10. Próximos pasos inmediatos
- Anexo A. Trazabilidad requerimiento → fase

---

## 1. Resumen ejecutivo

**Qué pide la estrategia.** Cambiar la venta de espacios prepagados por meses por un esquema «paga lo que usas»: un catálogo gratuito, espacios que se cobran por día a fin de mes con dos tarifas (sin publicar y publicado), un programa de Socios Fundadores en tres olas y un anuncio Normal gratis para usuarios registrados.

**Decisiones del propietario (2026-10-19):**

- **Lanzamiento solo en Web.** Android, iOS y Windows vienen después.
- **Mes calendario cobrado por día.** Las tarifas **no incluyen IVA**.
- **Hasta 60 fotos por espacio.**
- **Socio Fundador:** además de publicar 3 propiedades en 15 días, el promotor debe tener **siempre al menos una publicación activa** (puede rotar entre propiedades). Si no publica las 3 propiedades, en el cierre se le cobra normalmente lo que tenga.
- **Este plan va antes que «Mi Asistente IA».** La captura de propiedades es manual, en «Mi Catálogo» y en «Mis Espacios», y no depende de la IA. La conserjería con IA (estrategia §4) pasa al plan de IA, después del lanzamiento.

**Qué ya existe.** Captura y publicación de propiedades; compra de espacios con Stripe Checkout (el servidor está listo, pero los pagos siguen deshabilitados hasta cargar claves y precios); buscador por tipo de propiedad, operación, tipo de anuncio y ubicación; contacto por teléfono, correo y chat interno; listas, grupos y conocidos.

**Qué falta, de mayor a menor riesgo:**

1. **El cobro pospago completo:** tarjeta guardada, consumo diario, cierre mensual, aviso 3 días antes, reintentos. No existe ninguna de estas piezas.
2. **Que el servidor controle publicar, despublicar y eliminar.** Hoy la app escribe directo en `buscobien_publicados_*`, así que no se podría cobrar con certeza lo que estuvo publicado ni comprobar la publicación continua.
3. «Mi Catálogo», «Mis Publicaciones» y el menú nuevo de «Mi cuenta».
4. El motor de promociones (olas, paquete, condición de entrada, publicación continua) y el anuncio Normal gratuito.
5. La verificación manual con INE y Constancia de Situación Fiscal (CSF) y una pantalla de operación.
6. Filtros avanzados (precio, recámaras, baños, m²) y contacto por WhatsApp.

**Decisiones de diseño que propone este plan:**

1. **Libro de consumo propio** en CouchDB y un cargo mensual con tarjeta guardada en Stripe. No se usan los medidores de Stripe Billing.
2. **Contratar, publicar, despublicar, cambiar de tipo y eliminar pasan a buscobien-api.** La app deja de escribir en las bases de publicados.
3. **El catálogo vive en una base cerrada servida por el API**, porque CouchDB no tiene permisos de lectura por documento y el catálogo es información privada del promotor.
4. **Transferir del catálogo a un espacio copia los datos y conserva el vínculo.** El catálogo es el registro maestro.
5. **Tarifas, olas y paquete van en archivos de configuración del servidor**, igual que los precios de hoy.
6. **Los tres primeros cierres mensuales se revisan a mano antes de cobrar.**

**Calendario.** 16 semanas de trabajo, del 19 de octubre de 2026 al 26 de febrero de 2027, con colchón en diciembre. **Lanzamiento comercial propuesto: lunes 1 de marzo de 2027, en Web.** Lanzar un día 1 hace coincidir cada ola con un mes calendario y con el ciclo de cobro.

**Condiciones para lanzar:** corte S5 del plan de seguridad, servidor de producción nuevo con la versión Web publicada, Stripe verificado en modo real, textos legales publicados y un cierre mensual simulado sin diferencias (sección 5.3).

---

## 2. Requerimientos de la estrategia frente al estado real

Verificado en el código el 2026-10-19. Los ID `R01`…`R22` se usan en el resto del plan.

| ID | Requerimiento (sección de la estrategia) | Estado real | Brecha | Fase |
|---|---|---|---|---|
| R01 | Publicación de propiedades (§1) | Captura en `buscobien_casas_comprados_<tipo>`. «Publicar» copia la ficha a `buscobien_publicados_<tipo>` escribiendo directo desde la app (`tus_espacios/http_publica_propiedad.dart`). «Dejar de publicar» y «Eliminar» existen (`ficha_propiedad_card.dart`, `ficha_propiedad_dialogos.dart`) | Las acciones deben pasar por el API para registrar el consumo | F1 |
| R02 | Buscador parametrizado con filtros avanzados (§1) | Filtra por tipo de propiedad, operación, tipo de anuncio y ubicación, con conteo (`inicio/http_find_propiedades_10en10.dart`) | Faltan precio, recámaras, baños, m² y estacionamientos. Esos campos se guardan como texto (`precioventa: ''`), así que un rango en Mango no funciona sin campos numéricos | F4 |
| R03 | Contacto directo por WhatsApp o correo (§1) | Teléfono (`tel:`), correo (`mailto:`) y chat interno (`propiedades/acciones_propiedad.dart`) | Falta WhatsApp | F4 |
| R04 | Fuera de la v1: gestión de proyectos, foros, agendas automatizadas, marketing (§1) | — | Quedan fuera del lanzamiento, junto con «Mi Asistente IA» (L22) | — |
| R05 | «Mi Catálogo» gratis, 3 fotos, altas, bajas y cambios (§2, §3) | No existe | Completa | F3 |
| R06 | Comprar espacios y transferir del catálogo; hasta 60 fotos (§2, §3) | Compra prepagada por meses (`POST /compras/checkout`); los espacios nacen vacíos al confirmar el pago (`src/compras/espacios.js`); no hay límite de fotos | Contratación pospago, transferencia y límite de 60 fotos | F1, F2, F3 |
| R07 | Switch de publicación; sigue publicado hasta apagarlo (§2) | Botones «Publicar» y «Dejar de publicar»; el espacio vence con la compra | Switch MD3 y renovación automática | F1 |
| R08 | «Mis Publicaciones» (§3) | No existe | Vista de solo lectura | F3 |
| R09 | Menú de «Mi cuenta» con 6 opciones (§3) | Promotor: Mis Espacios, Mis Listas, Mis Grupos, Mis Conocidos. Usuario: Mis Listas, Mis Grupos, Mis Conocidos. Los otros 7 perfiles ven la sección vacía | Menú nuevo y navegación por enum | F3 |
| R10 | Cargar el catálogo con «Mi Asistente IA» desde PDF o Word (§3, §4) | Solo existe el plan de integración, sin código | **Fuera del lanzamiento** (L22). La captura manual en «Mi Catálogo» y «Mis Espacios» cubre el MVP | Plan de IA |
| R11 | Capturar y modificar los datos del espacio, y eliminarlo (§3) | Existe (`form_update_espacio_comprado.dart`, diálogo de eliminar) | Eliminar por el API y detener el consumo | F1 |
| R12 | Aviso 3 días antes del corte con espacios y costo (§2) | El API no tiene tareas programadas. `buscobien-mailer` envía hoy solo correos de recuperación | Tarea programada, correo y aviso en la app | F2 |
| R13 | Cobro automático con Stripe y tarjeta guardada (§2, §4) | Stripe Checkout en modo de pago único; sin `Customer` ni tarjeta guardada; pagos deshabilitados hasta cargar las claves | Tarjeta guardada y cargos fuera de sesión | F2 |
| R14 | Tarifas por tipo, sin publicar y publicado (§5) | `config/precios.ejemplo.json` con un solo precio mensual por tipo, de ejemplo (`confirmado: false`); IVA del 16 % sumado aparte | Tabla de 10 tarifas sin IVA | F2 |
| R15 | Cobro a fin de mes calendario, proporcional a los días (§5) | Prepago por meses | Motor de consumo y cierre | F2 |
| R16 | Socio Fundador, olas 1 a 3 (§3) | No existe | Motor de promociones | F6 |
| R17 | Condición de 3 propiedades en 15 días y publicación continua (§3 y L12–L13) | No existe | Seguimiento automático y revisión por un operador | F5, F6 |
| R18 | Al terminar los meses bonificados, precios normales (§3) | — | Lo resuelve el motor de consumo | F2, F6 |
| R19 | Usuario registrado: 1 anuncio Normal gratis; puede cambiarlo a Sobresaliente o Relevante pagando (§3) | El perfil Usuario no publica: `pagina_tus_espacios.dart` muestra «Ingresa como promotor para publicar propiedades» | Espacio gratuito, cambio de tipo y menú del Usuario | F6 |
| R20 | INE y CSF (§4) | No existe | Carga, resguardo y revisión, sin depender de la IA | F5 |
| R21 | Flutter + Node.js/CouchDB + Stripe (§4) | Coincide. Pendientes: corte S5 y servidor de producción nuevo (`plan_seguridad_nginx_jwt.md`) | Condiciones para lanzar; versión Web en producción | F7 |
| R22 | Interfaz MD3 (§2) | MD3 con `appTheme` (ADR-009) | Usar `Switch` de MD3 y `antigravity_ui_rules.md` | Todas |

**Permisos actuales que el plan cambia** (`buscobien-api/scripts/s4/reglas.mjs`):

- `buscobien_publicados_*`: lectura sin sesión; escribe el dueño. Con el cobro, solo debe escribir la cuenta de servicio.
- `buscobien_casas_comprados_*`: lectura con sesión; escribe el dueño, incluidos `activa` y `tipodeanuncio`. Esos campos deben quedar protegidos.

---

## 3. Decisiones

### 3.1 Decisiones tomadas (2026-10-19)

| # | Tema | Decisión del propietario | Efecto en el plan |
|---|---|---|---|
| L2 | Fotos por espacio | Límite de 60 | Configurable en el servidor; la app lo aplica antes de subir (sección 4.7) |
| L4 | Periodo de cobro | Mes calendario, cobrado por día | Importe = tarifa × días con consumo ÷ días del mes; un mes completo cuesta exactamente la tarifa. Cada día se cobra con la tarifa más alta que tuvo. Hora de la Ciudad de México |
| L6 | IVA | Las tarifas **no** incluyen IVA | El estado de cuenta suma el IVA (16 %) sobre el subtotal, como ya hace `calcularCompra`. La app muestra siempre el total con IVA junto a la tarifa, porque la Ley Federal de Protección al Consumidor pide exhibir el precio total |
| L12–L13 | Condición del Socio Fundador y qué pasa si no se cumple | Si no publica sus 3 propiedades, en el cierre se le presenta el cálculo de los espacios que tenga y de la propiedad o dos propiedades que tenga. Además, debe tener una propiedad publicada de forma continua (puede ser distinta) durante el mes: siempre una publicación | Dos condiciones: **entrada** (3 propiedades en 15 días) y **permanencia** (nunca quedarse sin publicaciones). Reglas completas en la sección 4.5; los puntos de interpretación están en la 3.2 |
| L21 | Plataformas del lanzamiento | Solo Web | Se retiran las tareas de tiendas. El código sigue considerando las 4 plataformas (regla de `CLAUDE.md`), pero para el lanzamiento solo se publica y se prueba la versión Web, también en navegadores de teléfono. Android, iOS y Windows se evalúan después, junto con las reglas de pago de las tiendas |
| L22 | Prioridad frente al plan «Mi Asistente IA» | Este plan va primero. La captura de propiedades en «Mis Espacios» es independiente de «Mi Asistente IA» | La captura es manual, en «Mi Catálogo» y en «Mis Espacios». La conserjería con IA y la pestaña «Mi Asistente IA» quedan fuera del lanzamiento. La verificación de INE y CSF se separa de la conserjería. Ya no aplica la antigua L17 (lugar de la IA en el menú) |

### 3.2 Puntos por confirmar de las respuestas

El plan aplica estas interpretaciones mientras no se indique otra cosa.

| # | Duda | Interpretación aplicada | Alternativa |
|---|---|---|---|
| L13a | Si no cumple la entrada, ¿desde cuándo se cobra? | **Desde el registro.** La bonificación de los primeros 15 días era provisional y, al perderse, esos días se cobran con las tarifas normales | Cobrar solo desde el día 16 |
| L23 | Si en un mes bonificado se queda sin publicaciones, ¿pierde toda la promoción o solo ese mes? | **Solo ese mes** se cobra con tarifas normales; la bonificación sigue en los meses siguientes | Pierde la promoción desde ese día |
| L24 | ¿Cuánto puede durar el hueco al cambiar de una publicación a otra? | **Tolerancia de 60 minutos**, configurable. Además, la app avisa antes de apagar la última publicación | Sin tolerancia (cualquier hueco cuenta) |
| L25 | ¿Desde cuándo se exige la publicación continua? | **Desde el día en que publica la tercera propiedad** y hasta el fin de la bonificación, cada mes calendario | Desde el primer día del registro |
| L12b | ¿Qué hace «reales» a las 3 propiedades? | Identidad verificada (INE y CSF) y revisión de un operador. Una publicación eliminada antes de la revisión no cuenta | Solo el conteo automático |

### 3.3 Decisiones pendientes

Si no se responde otra cosa, el plan usa la recomendación.

| # | Tema | Qué dice la estrategia | Recomendación |
|---|---|---|---|
| L1 | Nombre del inventario gratuito | «Mi Cartera» (§2) y «Mi Catálogo» (§3) | «Mi Catálogo» en la interfaz |
| L3 | Nombres de los tipos | Sobresaliente, Relevante, Normal, Oportunidades, Remates. El código usa `superdestacados`, `destacados`, `normales`, `oportunidades`, `remates` | Sobresaliente = `superdestacados`, Relevante = `destacados`. Cambian solo las etiquetas; claves y bases se conservan |
| L5 | Momento del cargo | «Al comprar un Espacio…» (§2) y «se cobra a finales de mes» (§5) | Pospago: contratar no cobra y el cargo llega al cierre. Para contratar un espacio con costo se pide tarjeta registrada |
| L7 | Cargo rechazado | No lo menciona | Reintentos a los 1, 3 y 5 días. Al día 7 sin pago, el sistema deja de publicar los anuncios (sin borrar datos) y bloquea contratar. Al pagar, el promotor vuelve a encender sus switches |
| L8 | Olas y fecha de lanzamiento | «primer, segundo y tercer mes» y «cerrando la ventana 2 o 3 meses después del lanzamiento comercial» | Lanzamiento el día 1 de un mes; la ola es el mes calendario de registro. Propuesta: 1 mar 2027 → Ola 1 marzo, Ola 2 abril, Ola 3 mayo |
| L9 | Quién entra a las olas | Habla de «el promotor» | Solo el perfil Promotor |
| L10 | Inicio de los meses bonificados | No lo dice | Desde la fecha de registro |
| L11 | Condición en la Ola 3 | Las olas 1 y 2 la piden; la 3 no la repite, pero la regla general sí | Las dos condiciones (entrada y permanencia) aplican a las tres olas |
| L14 | Cuentas creadas antes del lanzamiento | No lo dice | Se tratan como registradas el día del lanzamiento (Ola 1) |
| L15 | Anuncio Normal gratuito | «usuario registrado», uno, sin plazo | Uno por cuenta, para cualquier perfil, sin vencimiento mientras la cuenta esté activa. No se suma al paquete de fundador mientras éste dure. Al cambiarlo a Sobresaliente o Relevante se cobra la tarifa completa del tipo nuevo |
| L16 | Menú de los demás perfiles | Describe un solo menú | Promotor: las 6 opciones. Usuario y los otros 7 perfiles: Mis Espacios (con el anuncio gratuito), Mis Publicaciones, Mis Listas, Mis Grupos y Mis Conocidos, sin «Mi Catálogo» |
| L18 | Transferir del catálogo al espacio | «transferir» | Copiar y vincular (`origenCatalogoId`). Al eliminar el espacio, la propiedad sigue en el catálogo; las fotos 4 a 60 se borran tras 30 días de gracia |
| L19 | Mecanismo de cobro en Stripe | «Stripe para pagos y almacenamiento seguro de tarjetas» | Tarjeta guardada con Checkout en modo `setup` y un `PaymentIntent` fuera de sesión por cierre, con el importe que calcula el libro propio. Stripe Invoicing o Billing se reconsideran si hacen falta sus reintentos y comprobantes (cobran comisión aparte; confirmarla en Stripe) |
| L20 | Facturas (CFDI) | Pide la CSF | Recolectar datos fiscales desde el inicio. CFDI manual con un PAC para quien lo pida en los primeros cierres; automatizarlo después del lanzamiento |

---

## 4. Diseño de la solución

### 4.1 Ciclo de vida de una propiedad

```
                                   costo
 ┌─────────────────────────┐
 │      Mi Catálogo        │  $0      captura manual: altas, bajas y cambios · 3 fotos
 └───────────┬─────────────┘
             │ Transferir (copia + vínculo) a un espacio libre o a uno nuevo
             ▼
 ┌─────────────────────────┐
 │      Mis Espacios       │  tarifa «sin publicar» por día
 │  switch apagado         │  captura manual directa · 60 fotos · eliminar espacio
 └───────────┬─────────────┘
    apagar ▲ │ encender
           │ ▼
 ┌─────────────────────────┐
 │    Mis Publicaciones    │  tarifa «publicado» por día
 │  (solo lectura)         │  visible en el buscador; se renueva cada mes hasta apagar el switch
 └─────────────────────────┘

 Eliminar el espacio (solo con el switch apagado): deja de cobrar; la propiedad sigue en Mi Catálogo.
```

- **Dos caminos de captura, ambos manuales.** Se puede dar de alta en «Mi Catálogo» y transferir, o contratar un espacio y capturar directo en «Mis Espacios» con el formulario actual (`form_update_espacio_comprado.dart`). Ninguno depende de «Mi Asistente IA».
- Si se elimina un espacio cuya propiedad no está en el catálogo, la app ofrece «Guardar en Mi Catálogo» (copia los datos y las 3 primeras fotos).
- Estados del espacio: `contratado` ⇄ `publicado` → `eliminado`. El sistema puede pasar un espacio a `suspendido` por cargo rechazado (L7); en ese estado no se publica y cobra la tarifa sin publicar.

### 4.2 Menú «Mi cuenta»

| Posición | Promotor | Usuario y otros perfiles (L16) |
|---|---|---|
| 0 | Mi Catálogo | Mis Espacios |
| 1 | Mis Espacios | Mis Publicaciones |
| 2 | Mis Publicaciones | Mis Listas |
| 3 | Mis Listas | Mis Grupos |
| 4 | Mis Grupos | Mis Conocidos |
| 5 | Mis Conocidos | — |

- La pantalla se elige por enum (`OpcionMiCuentaPromotor`, `OpcionMiCuentaUsuario`), no por índice. Hoy `buttonSelectOpcion` tiene posiciones fijas que se reinician a mano (`provider_menu_tu_cuenta.dart`).
- Las páginas de `lib/03_vistas/` (hospedaje, promotores, propietarios) saltan a «Mi cuenta» con índices numéricos fijos. Se cambian por la enum.
- Con 6 pestañas, la barra (`ButtonsTabBar`) debe desplazarse horizontalmente en el navegador de un teléfono (360 px de ancho).
- Corrige de paso un hallazgo del plan de IA: los perfiles Propietario, Anfitrión, Vendedor, Especialista, Proveedor, Asociación e Inmobiliaria hoy ven «Mi cuenta» vacía.

### 4.3 Modelo de cobro

**Tarifas** (estrategia §5; claves según L3). No incluyen IVA (L6); la columna «con IVA» es la que la app muestra junto a cada tarifa.

| Tipo (clave) | Sin publicar, por mes | Con IVA | Publicado, por mes | Con IVA |
|---|---|---|---|---|
| Sobresaliente (`superdestacados`) | $225.00 | $261.00 | $900.00 | $1,044.00 |
| Relevante (`destacados`) | $125.00 | $145.00 | $500.00 | $580.00 |
| Normal (`normales`) | $50.00 | $58.00 | $200.00 | $232.00 |
| Oportunidades (`oportunidades`) | $50.00 | $58.00 | $200.00 | $232.00 |
| Remates (`remates`) | $50.00 | $58.00 | $200.00 | $232.00 |

**Reglas:**

1. Cada espacio acumula un día de consumo por cada día del mes en que existió, con la tarifa más alta que tuvo ese día (L4).
2. Línea = tarifa × días ÷ días del mes, redondeada a centavos por línea. Todo en centavos enteros, como hoy.
3. IVA = 16 % del subtotal del estado de cuenta, redondeado a centavos. Total = subtotal + IVA.
4. Los espacios dentro del paquete de fundador valen $0 mientras se cumplan las condiciones de la sección 4.5; se muestran como descuento, no se ocultan. Durante los primeros 15 días el descuento es **provisional**.
5. El anuncio Normal gratuito vale $0 (L15).
6. **Cierre:** el día 1 a las 00:15, hora de la Ciudad de México, se cierra el mes anterior. Se genera el estado de cuenta y, si el total es mayor que cero, se intenta el cargo. Si el total no llega al importe mínimo de cargo de Stripe para MXN (confirmarlo en Stripe), se acumula al mes siguiente.
7. **Aviso a 3 días:** el antepenúltimo día del mes a las 10:00. Contiene:
   - los espacios sin publicar y publicados por tipo;
   - el cargo estimado de este cierre, con IVA;
   - la proyección del mes siguiente si nada cambia;
   - si aplica, el fin de la bonificación o el riesgo de perderla.

   Ofrece dos acciones y explica su efecto: «Dejar de publicar» (sigue costando la tarifa sin publicar) y «Eliminar espacio» (deja de costar). Llega por correo (`buscobien-mailer`) y como aviso en la app (sondeo, igual que el chat; Web Push con FCM cuando exista).
8. **Cargo rechazado:** según L7.
9. **Los tres primeros cierres** se generan con `COBRO_AUTOMATICO=false`: un operador revisa los estados de cuenta y autoriza el cargo.

**Ejemplo.** Un espacio Relevante contratado el 10 de marzo (31 días) y publicado el 15 hasta fin de mes:

| Concepto | Días | Cálculo | Importe |
|---|---|---|---|
| Sin publicar, 10 a 14 de marzo | 5 | 125.00 × 5 ÷ 31 | $20.16 |
| Publicado, 15 a 31 de marzo | 17 | 500.00 × 17 ÷ 31 | $274.19 |
| Subtotal | | | $294.35 |
| IVA (16 %) | | 294.35 × 0.16 | $47.10 |
| **Total del cierre del 1 de abril** | | | **$341.45** |

### 4.4 Stripe: tarjeta guardada y cargo mensual

1. **Registrar la tarjeta:** `POST /facturacion/tarjeta` crea un Checkout en modo `setup` y devuelve la URL. En Web la app redirige a Stripe en la misma pestaña, y Stripe regresa a `buscobien.net` (`success_url` y `cancel_url`). La página de regreso consulta el estado al API, igual que `pagina_estado_compra.dart`. La app nunca maneja datos de tarjeta. El webhook guarda el método de pago predeterminado del `Customer`. La página muestra el consentimiento para cargos recurrentes a fin de mes.
2. **Cargo del cierre:** `PaymentIntent` con `customer`, `payment_method`, `off_session: true` y `confirm: true`. La clave de idempotencia es el id del estado de cuenta.
3. **Resultado por webhook:** `payment_intent.succeeded` marca el estado de cuenta como pagado. Si el cargo falla o el banco pide autenticación, queda pendiente y el aviso lleva un enlace de pago (Checkout en modo `payment` por el adeudo).
4. **Retiro del prepago:** al terminar F2 se retira `POST /compras/checkout`. `buscobien_compra_espacios` queda como historial de solo lectura.
5. Siguen vigentes las reglas actuales: el servidor calcula todos los importes, la app nunca los envía y no se exponen identificadores de Stripe.

### 4.5 Promociones: Socio Fundador y anuncio gratuito

**Configuración** en `buscobien-api/config/promociones.json`, con el mismo patrón que `precios.json` (sin `confirmado: true` no se aplica):

```json
{
  "confirmado": false,
  "fechaLanzamiento": "2027-03-01",
  "zonaHoraria": "America/Mexico_City",
  "perfiles": ["Promotor"],
  "paqueteFundador": { "superdestacados": 2, "destacados": 5, "normales": 20, "oportunidades": 5, "remates": 20 },
  "condicionEntrada": { "propiedadesPublicadas": 3, "dias": 15 },
  "condicionPermanencia": { "publicacionesMinimas": 1, "toleranciaMinutos": 60 },
  "olas": [
    { "ola": 1, "registroDesde": "2027-03-01", "registroHasta": "2027-03-31", "mesesBonificados": 6 },
    { "ola": 2, "registroDesde": "2027-04-01", "registroHasta": "2027-04-30", "mesesBonificados": 4 },
    { "ola": 3, "registroDesde": "2027-05-01", "registroHasta": "2027-05-31", "mesesBonificados": 2 }
  ],
  "anuncioGratuito": { "tipo": "normales", "cantidad": 1 }
}
```

**Condiciones del Socio Fundador** (L12–L13; interpretaciones de la sección 3.2):

1. **Entrada.** Publicar 3 propiedades distintas dentro de los primeros 15 días naturales desde el registro. Las revisa un operador (L12b).
2. **Permanencia.** Desde la publicación de la tercera propiedad y hasta el fin de la bonificación, tener **siempre al menos una publicación activa**. Puede ser una propiedad distinta cada vez. Un hueco menor que la tolerancia (60 minutos, L24) no cuenta.
3. **Si no cumple la entrada:** pierde la promoción. En el siguiente cierre se le presenta el cálculo normal de los espacios que tenga y de la propiedad o dos propiedades que haya publicado, desde su registro (L13a). Si los 15 días cruzan un cierre, ese cierre sale en $0 como «provisional» y los días se cobran en el cierre siguiente, en una línea «Ajuste por promoción no cumplida».
4. **Si en un mes bonificado queda sin publicaciones:** ese mes se cobra con tarifas normales y la bonificación sigue el mes siguiente (L23).
5. Los espacios fuera del paquete se cobran siempre.

**Estados del beneficio:**

```
registro en una ola ──► condicionado (días 1–15; bonificación provisional)
   ├── 3 publicaciones en 15 días ──► activo
   │        ├── mes con publicación continua ──► mes bonificado ($0 dentro del paquete)
   │        ├── mes con un hueco ──────────────► mes cobrado con tarifas normales (L23)
   │        └── fin de los meses ──────────────► concluido
   └── día 16 sin 3 publicaciones ──► perdido (cobro normal desde el registro, L13a)
```

**Cómo se evita que el promotor pierda la bonificación por descuido:**

- Al apagar el switch de su **última** publicación durante la bonificación, la app muestra un diálogo: «Te quedarás sin publicaciones y este mes se cobrará con tarifas normales. Publica otra propiedad primero».
- Si de todos modos se queda sin publicaciones (por ejemplo, por una suspensión), recibe un aviso inmediato por correo y en la app con el plazo de tolerancia.
- Avisos de la entrada: días 7 y 12 («te faltan N propiedades; si no las publicas, en el cierre pagarás aproximadamente $X»), y día 15 (resultado).
- Avisos del fin: 30 y 7 días antes del fin de la bonificación (registrar tarjeta y ver el costo que viene).
- En «Mis Espacios», una tarjeta «Socio Fundador» muestra la ola, el avance de la entrada (por ejemplo, 2 de 3), los días que quedan, el estado de la permanencia del mes, los meses bonificados restantes y el paquete usado por tipo. «Mi consumo» muestra lo que se cobraría si la condición no se cumple.

**Otras reglas:**

- `POST /auth/register` crea el beneficio cuando la fecha cae en una ola y el perfil es Promotor. Las cuentas previas lo reciben el día del lanzamiento (L14).
- Contratar un espacio dentro del paquete no pide tarjeta. Contratar fuera del paquete sí (L5).
- La permanencia se calcula con la bitácora de eventos (`publicar`, `despublicar`, `eliminar`, `suspender`): los intervalos de publicación unidos deben cubrir el periodo exigido.

### 4.6 Verificación de identidad y operación

La estrategia pide INE y CSF durante la conserjería. Como la conserjería con IA sale del lanzamiento (L22), la verificación se separa y se pide por su cuenta:

1. En la tarjeta «Socio Fundador» de «Mis Espacios», el botón «Verificar mi identidad» abre la carga de la INE (frente y reverso) y la CSF (PDF). Se usa `file_picker` (entrada de archivo en Web).
2. El documento queda `pendiente`. Un operador lo revisa y lo aprueba o lo rechaza con un motivo.
3. La condición de entrada solo se confirma con la verificación aprobada (L12b).

**Reglas de los documentos de identidad:**

- Nunca se guardan en bases abiertas. Cuando llegue la IA, tampoco se le envían.
- Solo los ve el rol `operador`, que el servidor emite en el JWT a partir de una lista de ids en su configuración.
- El aviso de privacidad debe cubrirlos y fijar su plazo de conservación.

**Pantalla «Operación»** (solo para el rol `operador`):

- Verificaciones pendientes.
- Condiciones de entrada por revisar, con las 3 publicaciones.
- Fundadores con un hueco de publicación en el mes.
- Estados de cuenta por autorizar (los tres primeros cierres).

### 4.7 Modelo de datos

**Bases nuevas**, cerradas a los clientes (solo la cuenta de servicio `buscobien_api`), con prefijo semántico en los `_id`:

| Base | `_id` | Contenido |
|---|---|---|
| `buscobien_catalogo` | `catalogo:uuid` | Propiedades del catálogo: esquema `espacioscasa` más `estadocomercial` (`disponible`, `apartada`, `vendida`, `rentada`), `origen` (`manual`; `asistente` cuando llegue la IA) y `espaciosVinculados` |
| `buscobien_facturacion` | `cliente:{userId}`, `evento:uuid`, `estadocuenta:{userId}:{aaaa-mm}`, `cargo:uuid` | Cliente de Stripe y tarjeta (marca y últimos 4 dígitos), bitácora de consumo, estados de cuenta y cargos |
| `buscobien_promociones` | `beneficio:{userId}` | Ola, fechas, paquete usado, avance de la entrada, cumplimiento de la permanencia por mes y estado |
| `buscobien_verificaciones` | `verificacion:{userId}` | Estado, motivo, quién revisó; adjuntos INE y CSF; datos fiscales |

Ejemplo de evento de consumo:

```json
{
  "_id": "evento:5c1f...",
  "type": "evento_consumo",
  "userId": "<id_usuario>",
  "espacioId": "espacio-<idPropiedad>",
  "tipo": "destacados",
  "accion": "publicar",
  "estadoAnterior": "contratado",
  "estadoNuevo": "publicado",
  "bonificado": false,
  "origen": "app",
  "fecha": "2027-03-15T17:42:10-06:00"
}
```

**Cambios en bases existentes** (con respaldo previo, según `CLAUDE.md`):

- `buscobien_casas_comprados_*`: campos `estadoEspacio`, `fechaContratacion`, `fechaEliminacion`, `bonificado`, `gratuito` y `origenCatalogoId`. Regla de validación nueva: el dueño captura y edita la ficha, pero solo la cuenta de servicio cambia `activa`, `tipodeanuncio`, `idusuario`, `estadoEspacio` y las fechas.
- `buscobien_publicados_*`: solo escribe la cuenta de servicio; la lectura sin sesión no cambia. Al publicar, el API agrega campos numéricos normalizados (`filtros.precio`, `filtros.recamaras`, `filtros.banos`, `filtros.m2Construidos`, `filtros.m2Terreno`, `filtros.estacionamientos`) e índices Mango para ellos.
- `buscobien_propiedades_casas_fotos`: campo `contexto` (`catalogo` o `espacio`). En el MVP la app aplica el límite (3 o 60) y una tarea diaria detecta excedentes. Mover la carga de fotos al API, con el límite en el servidor, queda para después del lanzamiento.
- `buscobien_compra_espacios`: historial de solo lectura.
- **Migración:** los espacios actuales se crearon con el flujo anterior y no hay pagos reales (Stripe sigue deshabilitado). Se respaldan, se les asignan `estadoEspacio` y `fechaContratacion`, y desde el lanzamiento entran al cobro o al paquete de fundador.

### 4.8 Endpoints de buscobien-api

Formato de error del proyecto: `{ error, code }`. Todos usan `requiereAuth`, salvo los webhooks. Cada módulo sigue el patrón de `src/compras/` y `src/social/` (rutas, servicio y repositorio).

| Método y ruta | Uso | Fase |
|---|---|---|
| `GET /espacios`, `POST /espacios` | Espacios propios; contratar `{ tipo, cantidad }` | F1 |
| `POST /espacios/:id/publicar`, `POST /espacios/:id/despublicar` | Switch de publicación; registran el evento | F1 |
| `POST /espacios/:id/cambiar-tipo` | Cambiar de tipo (por ejemplo, el Normal gratuito a Relevante); mueve los documentos entre las bases del tipo | F1 |
| `DELETE /espacios/:id` | Eliminar (solo con el switch apagado) | F1 |
| `GET /tarifas` | Tabla de 10 tarifas sin IVA y la tasa de IVA; sustituye a `GET /compras/precios` | F2 |
| `POST /facturacion/tarjeta`, `GET /facturacion/tarjeta`, `DELETE /facturacion/tarjeta` | Registrar, ver (marca y últimos 4) o retirar la tarjeta | F2 |
| `GET /facturacion/estado` | Consumo del mes en curso, proyección, adeudos y beneficio | F2 |
| `GET /facturacion/estados-cuenta`, `GET /facturacion/estados-cuenta/:periodo` | Historial de cierres | F2 |
| `POST /facturacion/pagar/:periodo` | Enlace de pago de un adeudo | F2 |
| `GET /operacion/estados-cuenta`, `POST /operacion/estados-cuenta/:id/autorizar` | Revisión de los primeros cierres | F2 |
| `GET /catalogo`, `POST /catalogo`, `GET`, `PUT` y `DELETE /catalogo/:id` | Altas, bajas y cambios del catálogo | F3 |
| `POST /catalogo/:id/transferir` | `{ espacioId }` a un espacio libre o `{ tipo }` para contratar uno | F3 |
| `POST /espacios/:id/guardar-en-catalogo` | Copia la ficha de un espacio al catálogo | F3 |
| `GET /publicaciones` | «Mis Publicaciones» | F3 |
| `POST /verificacion` (multipart), `GET /verificacion` | INE y CSF del propio usuario | F5 |
| `GET /operacion/verificaciones`, `POST /operacion/verificaciones/:userId` | Bandeja y decisión del operador | F5 |
| `GET /promociones/mi-beneficio` | Estado del Socio Fundador y del anuncio gratuito | F6 |
| `GET /operacion/fundadores`, `POST /operacion/fundadores/:userId/entrada` | Revisión de las 3 publicaciones y de los huecos del mes | F6 |
| `POST /webhooks/stripe` (existente) | Eventos nuevos: `checkout.session.completed` en modo `setup`, `payment_intent.succeeded`, `payment_intent.payment_failed` | F2 |

**Tareas programadas** (temporizadores de systemd que ejecutan scripts de Node; todas idempotentes y con reloj inyectable para las pruebas):

| Tarea | Cuándo | Qué hace |
|---|---|---|
| `aviso-corte` | Antepenúltimo día del mes, 10:00 | Aviso a 3 días |
| `cierre-mensual` | Día 1, 00:15 | Estados de cuenta (con ajustes de promociones no cumplidas) y cargos |
| `reintentos-cobro` | Diario | Reintentos y suspensión (L7) |
| `condicion-fundador` | Cada hora | Avance de la entrada, huecos de publicación, avisos y pérdida |
| `fin-bonificacion` | Diario | Avisos a 30 y 7 días; cierre del beneficio |
| `fotos` | Diario | Excedentes del límite y purga tras los 30 días de gracia (L18) |

En nginx, cuerpo mayor solo en `POST /verificacion` (por ejemplo, 15 MB).

### 4.9 Cambios previstos en la app

| Archivo o carpeta | Cambio |
|---|---|
| `lib/20_var_globales/var_elementos_menus.dart` | Elementos `iconoMiCatalogo` e `iconoMisPublicaciones`; etiquetas Sobresaliente y Relevante (L3) donde se muestren los tipos |
| Nuevo `lib/05_provider_menus/opciones_mi_cuenta.dart` | Enums `OpcionMiCuentaPromotor` y `OpcionMiCuentaUsuario` |
| `lib/05_provider_menus/provider_menu_tu_cuenta.dart` y `provider_menu_tu_cuenta_usuario.dart` | Listas nuevas; `buttonSelectOpcion` se genera a partir de la longitud |
| `lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart` | Rama `indiceInicial == 3`: pantalla por enum y menú para todos los perfiles |
| `lib/03_vistas/` (hospedaje, promotores, propietarios) | Saltos a «Mi cuenta» por enum |
| Nueva `lib/08_pantallas/tu_cuenta/mi_catalogo/` | `catalogo_api.dart`, modelos Freezed, providers, página, ficha y formulario (reutiliza los campos de `tus_espacios/edicion/`) y botón «Transferir» |
| Nueva `lib/08_pantallas/tu_cuenta/mis_publicaciones/` | Lista de solo lectura con acceso a la ficha en «Mis Espacios» |
| Nueva `lib/08_pantallas/tu_cuenta/facturacion/` | `facturacion_api.dart`, «Mi consumo» (mes en curso con IVA y proyección), tarjeta, estados de cuenta, avisos y tarjeta «Socio Fundador» con «Verificar mi identidad» |
| `lib/08_pantallas/tu_cuenta/tus_espacios/` | `espacios_api.dart`; `Switch` MD3 en la ficha; publicar, despublicar, cambiar tipo y eliminar por el API; diálogo al apagar la última publicación durante la bonificación; «Guardar en Mi Catálogo» al eliminar; se retiran las escrituras de `http_publica_propiedad.dart`; contratar sin meses en lugar de `form_compra_espacios.dart`. La captura manual con `form_update_espacio_comprado.dart` se conserva |
| `lib/22_imagenes/tus_espacios_fotos_propiedad/` | Límite por contexto (3 o 60) antes de subir |
| `lib/08_pantallas/propiedades/acciones_propiedad.dart` | Contacto por WhatsApp (`https://wa.me/<número>` con mensaje que incluye la clave de la propiedad) |
| `lib/08_pantallas/inicio/` | Filtros avanzados sobre `filtros.*` en la búsqueda y en el conteo |
| `lib/10_user_login/` | Aceptación de términos y aviso de privacidad en el registro; aviso de la ola y de sus condiciones al registrarse |
| Nueva `lib/08_pantallas/operacion/` | Pantalla del rol `operador` |

**Plataformas.** El lanzamiento es solo Web (L21), así que la prueba y la publicación se hacen en Web (WASM). El código sigue las reglas de las 4 plataformas de `CLAUDE.md` para no cerrar la puerta a las apps. Aplican las convenciones del proyecto: widgets de menos de unas 80 líneas, constructores `const`, `try/catch` en cada llamada asíncrona, `if (!mounted) return;` después de cada `await` en widgets con estado, colores solo por `appTheme.*` y compatibilidad con WASM verificada antes de agregar cualquier paquete. No hace falta ningún paquete nuevo: `url_launcher` y `file_picker` ya están en `pubspec.yaml`.

### 4.10 Relación con el plan «Mi Asistente IA»

| Tema del plan de IA | Ajuste (L22) |
|---|---|
| Calendario (empezaba el 19 de octubre de 2026) | Hay que reprogramarlo para después del lanzamiento |
| Pestaña «Mi Asistente IA» en la posición 0 del menú | Fuera del lanzamiento. Su lugar en el menú se decide en ese plan, sobre el menú de la sección 4.2 |
| Ingesta de fichas (su fase 3) y conserjería (estrategia §4) | Fuera del lanzamiento. Cuando llegue, creará borradores en «Mi Catálogo» (no en espacios comprados), así que no cambia el ciclo de la sección 4.1 |
| Decisión 5: «la ingesta crea un borrador que se asigna a un espacio comprado» | Se sustituye por el borrador en «Mi Catálogo» y la transferencia normal |
| Decisión D1 (¿«Mis Listas» se queda?) | Se queda, en la posición 3 |
| Campo `estadocomercial` en las propiedades | Se adopta en `buscobien_catalogo` |
| Verificación de identidad | La entrega este plan (F5); el plan de IA la reutiliza y nunca envía los documentos al modelo |
| Condiciones de arranque: corte S5 y nodo IA propio | El corte S5 lo cumple este plan. El nodo IA deja de ser condición del lanzamiento |

---

## 5. Plan por fases

### 5.1 Calendario

| Fase | Semanas | Fechas | Resultado |
|---|---|---|---|
| F0 · Decisiones y preparación | S1 | 19–23 oct 2026 | Puntos de 3.2 y 3.3 resueltos; ADR y Epics en borrador; trámites con tiempos largos iniciados |
| F1 · Espacios gobernados por el API | S2–S3 | 26 oct – 6 nov | Contratar, publicar, despublicar, cambiar tipo y eliminar por el API, con bitácora de eventos; switch MD3 |
| F2 · Cobro pospago con Stripe | S4–S6 | 9–27 nov | Tarjeta guardada, motor de consumo con IVA, cierre, aviso a 3 días, reintentos, «Mi consumo» |
| F3 · Mi Catálogo, Mis Publicaciones y menú | S7–S8 | 30 nov – 11 dic | Menú de 6 opciones; catálogo con transferencia |
| Colchón | — | 14 dic 2026 – 1 ene 2027 | Correcciones y vacaciones |
| F4 · Búsqueda y contacto | S9 | 4–8 ene 2027 | Filtros avanzados y WhatsApp |
| F5 · Verificación de identidad y operación | S10 | 11–15 ene | INE y CSF, rol y pantalla de operación |
| F6 · Socio Fundador y anuncio gratuito | S11–S13 | 18 ene – 5 feb | Olas, paquete, entrada, permanencia, anuncio Normal gratis, menú del Usuario |
| F7 · Producción Web y beta cerrada | S14–S16 | 8–26 feb | Servidor nuevo, corte S5, Stripe real, versión Web publicada, beta con 5 a 10 promotores |
| **Lanzamiento comercial (Web)** | — | **lunes 1 mar 2027** | Inicia la Ola 1 |
| F8 · Operación de las olas | — | mar – may 2027 | Primer cierre real el 1 de abril; seguimiento semanal; CFDI automatizado; Web Push |

### 5.2 Detalle por fase

#### F0 · Decisiones y preparación (S1)

| | |
|---|---|
| **Objetivo** | Cerrar las dudas restantes y arrancar lo que tarda semanas fuera del código |
| **Tareas** | 1. El propietario confirma las interpretaciones de la sección 3.2 y responde la 3.3 (o acepta las recomendaciones).<br>2. Fijar la tabla de tarifas definitiva, sin IVA.<br>3. Iniciar la verificación de la cuenta de Stripe para modo real (la guía `guia_habilitar_stripe.md` advierte que tarda días) y completar los pasos 1 a 6 en modo de prueba.<br>4. Encargar los textos legales: términos con cargos recurrentes, aviso de privacidad (INE y CSF) y bases de la promoción Socio Fundador, incluidas la condición de permanencia y el cobro al no cumplir la entrada.<br>5. Respaldar las bases de espacios, publicados, fotos y compras.<br>6. ADR en borrador (sección 7) y Epics semilla `REQ-CAT`, `REQ-FAC`, `REQ-PRO` y `REQ-VER`.<br>7. Reprogramar el calendario del plan «Mi Asistente IA» para después del lanzamiento. |
| **Entregables** | Decisiones registradas; `precios` v2 y `promociones.json` en borrador; ADR y Epics en borrador; respaldo verificado |
| **Dependencias** | Ninguna |

#### F1 · Espacios gobernados por el API (S2–S3)

| | |
|---|---|
| **Objetivo** | Que todo cambio de estado de un espacio pase por el servidor y quede registrado |
| **Tareas API** | 1. Módulo `src/espacios/` con los endpoints de la sección 4.8 y la bitácora `evento:`.<br>2. `POST /espacios` contrata sin cobro (el cobro llega en F2); los espacios se crean con la `plantillaEspacio` existente.<br>3. Al publicar, copiar a `buscobien_publicados_<tipo>` y calcular los campos `filtros.*`; crear sus índices Mango.<br>4. `cambiar-tipo`: mover el espacio y, si está publicado, su publicación, entre las bases del tipo, en un orden que no deje huérfanos.<br>5. Reglas S4: escritura de `buscobien_publicados_*` solo para la cuenta de servicio; validación de campos protegidos en `buscobien_casas_comprados_*`. Ampliar la matriz de pruebas de `scripts/s4`.<br>6. Migrar los espacios existentes (sección 4.7). |
| **Tareas app** | 1. `espacios_api.dart` y retiro de las escrituras directas.<br>2. `Switch` MD3 en la ficha; «Eliminar» deshabilitado con el switch encendido (la regla actual se conserva).<br>3. Etiquetas Sobresaliente y Relevante.<br>4. Límite de 60 fotos al subir. |
| **Entregables** | Módulo de espacios con pruebas; reglas S4 aplicadas en desarrollo; app que publica y despublica por el API |
| **Criterios de aceptación** | Publicar y despublicar desde la app crea un evento cada vez. Un cliente que intenta escribir en `buscobien_publicados_*` o cambiar `activa` recibe 403. El buscador sigue mostrando lo publicado. La captura manual en «Mis Espacios» funciona igual que hoy |
| **Dependencias** | F0 (L3, L18) |

#### F2 · Cobro pospago con Stripe (S4–S6)

| | |
|---|---|
| **Objetivo** | Cobrar a fin de mes lo que cada espacio consumió, con IVA, aviso previo y sin sorpresas |
| **Tareas API** | 1. `precios` v2 (10 tarifas sin IVA y la tasa de IVA) con validación, como `validarPrecios`.<br>2. **Motor de consumo** como función pura (eventos + tarifas + beneficio + mes → líneas, subtotal, IVA y total), con la tabla de casos de la sección 6. Debe aceptar desde ahora las líneas de bonificación y de ajuste que usará F6.<br>3. `cliente:` y tarjeta con Checkout en modo `setup`; webhook ampliado.<br>4. Tareas `cierre-mensual`, `aviso-corte` y `reintentos-cobro`; plantillas de correo en `buscobien-mailer`.<br>5. `COBRO_AUTOMATICO=false` y autorización del operador por endpoint (la pantalla llega en F5).<br>6. Contratar fuera del paquete exige tarjeta.<br>7. Retirar `POST /compras/checkout` y actualizar el README. |
| **Tareas app** | 1. Pantalla «Mi consumo»: mes en curso con IVA, proyección, estados de cuenta y tarjeta.<br>2. Aviso dentro de la app (banner en «Mis Espacios» y en «Mi cuenta») cuando hay aviso de corte o adeudo.<br>3. Contratar espacios sin meses, con la tarifa y el total con IVA a la vista.<br>4. Páginas de regreso de Stripe (`success_url` y `cancel_url`) en Web. |
| **Entregables** | Módulo `src/facturacion/`; tareas programadas en `deploy/`; guía de Stripe actualizada |
| **Criterios de aceptación** | Con un reloj simulado, un mes completo de eventos produce exactamente los importes de la tabla de casos, IVA incluido. En el modo de prueba de Stripe: un cargo aprobado, uno rechazado que sigue L7 y uno que pide autenticación y se paga con el enlace. El aviso a 3 días llega por correo y aparece en la app |
| **Dependencias** | F1; tarifas (F0) |

#### F3 · Mi Catálogo, Mis Publicaciones y menú (S7–S8)

| | |
|---|---|
| **Objetivo** | El recorrido completo catálogo → espacio → publicación en la app |
| **Tareas API** | 1. `buscobien_catalogo` con sus índices; módulo `src/catalogo/`.<br>2. Transferencia: copiar la ficha y las 3 fotos al espacio y registrar el vínculo en los dos lados.<br>3. «Guardar en Mi Catálogo» desde un espacio.<br>4. `GET /publicaciones`. |
| **Tareas app** | 1. Enums del menú y menú nuevo (sección 4.2) para todos los perfiles.<br>2. «Mi Catálogo»: lista, ficha, alta, edición y baja, con 3 fotos.<br>3. Botón «Transferir» con selector de espacio libre o contratación.<br>4. «Mis Publicaciones».<br>5. Saltos de `03_vistas/` por enum. |
| **Entregables** | Módulos `mi_catalogo/` y `mis_publicaciones/`; menú nuevo |
| **Criterios de aceptación** | Un promotor da de alta una propiedad en el catálogo, la transfiere, la publica, la ve en «Mis Publicaciones» y en el buscador, la despublica y elimina el espacio; la propiedad sigue en el catálogo. Otro promotor contrata un espacio, captura directo en «Mis Espacios» y publica sin pasar por el catálogo. Todo funciona en Web (WASM), en escritorio y en el navegador de un teléfono |
| **Dependencias** | F1; F2 para contratar con cobro |

#### F4 · Búsqueda y contacto (S9)

| | |
|---|---|
| **Objetivo** | Completar las dos funciones centrales de la v1 que faltan |
| **Tareas** | 1. Filtros de precio (rango), recámaras, baños, m² y estacionamientos, en la búsqueda y en el conteo.<br>2. Botón de WhatsApp: número normalizado a +52, mensaje con el nombre y la clave de la propiedad. Se muestra solo si el anunciante tiene celular.<br>3. Registrar los clics de contacto (WhatsApp, correo, teléfono, chat) para los indicadores. |
| **Criterios de aceptación** | Un filtro de precio devuelve solo publicaciones dentro del rango y el conteo coincide. WhatsApp abre WhatsApp Web en escritorio y la app de WhatsApp desde el navegador del teléfono |
| **Dependencias** | F1 (campos `filtros.*`) |

#### F5 · Verificación de identidad y operación (S10)

| | |
|---|---|
| **Objetivo** | Tener la verificación manual y las herramientas del operador antes del motor de promociones |
| **Tareas API** | 1. `buscobien_verificaciones` y endpoints de verificación.<br>2. Rol `operador` emitido por el servidor y endpoints `/operacion/*` de verificaciones y estados de cuenta. |
| **Tareas app** | 1. Carga de INE y CSF («Verificar mi identidad»).<br>2. Pantalla «Operación»: verificaciones y estados de cuenta por autorizar. |
| **Criterios de aceptación** | Un usuario sin rol `operador` recibe 403 en `/operacion/*`. Los documentos de identidad no aparecen en ninguna base abierta. Un operador aprueba y rechaza con motivo, y el usuario ve el resultado |
| **Dependencias** | F2; aviso de privacidad (F0) |

#### F6 · Socio Fundador y anuncio gratuito (S11–S13)

| | |
|---|---|
| **Objetivo** | Aplicar las olas, sus dos condiciones y el anuncio gratuito sin trabajo manual, salvo la revisión |
| **Tareas API** | 1. `promociones.json` con validación; base `buscobien_promociones`.<br>2. Beneficio al registrarse y para las cuentas previas (L14).<br>3. Tarea `condicion-fundador`: entrada en 15 días, huecos de publicación con la tolerancia, avisos y pérdida.<br>4. Tarea `fin-bonificacion`.<br>5. El motor de consumo aplica el paquete, la bonificación provisional, el cobro desde el registro al perder la entrada (L13a), el mes con hueco (L23) y el anuncio gratuito. Se amplía la tabla de casos.<br>6. Anuncio Normal gratuito para todos los perfiles y `cambiar-tipo` con cobro.<br>7. Endpoints `/operacion/fundadores`. |
| **Tareas app** | 1. Tarjeta «Socio Fundador» con avance de la entrada y estado de la permanencia.<br>2. Diálogo al apagar la última publicación durante la bonificación.<br>3. Sección de fundadores en la pantalla «Operación».<br>4. Menú del Usuario y demás perfiles con «Mis Espacios» y «Mis Publicaciones».<br>5. Aviso de la ola y de sus condiciones en el registro, con enlace a las bases de la promoción. |
| **Criterios de aceptación** | Simulaciones con reloj:<br>• Un fundador de la Ola 1 que cumple las dos condiciones paga $0 dentro del paquete durante 6 meses y la tarifa normal desde el día siguiente.<br>• Uno que publica solo 2 propiedades paga en el cierre los espacios y las publicaciones desde su registro.<br>• Uno que rota publicaciones con un hueco de 10 minutos conserva el mes.<br>• Uno que queda 2 días sin publicaciones paga ese mes completo y recupera la bonificación el mes siguiente.<br>• Un excedente fuera del paquete se cobra.<br>• Un Usuario publica un Normal gratis y paga al cambiarlo a Relevante. |
| **Dependencias** | F2; F5; textos legales (F0) |

#### F7 · Producción Web y beta cerrada (S14–S16)

| | |
|---|---|
| **Objetivo** | Cumplir las condiciones para lanzar (sección 5.3) |
| **Tareas** | 1. Servidor de producción nuevo según la sección 10 de `plan_seguridad_nginx_jwt.md` (2 vCPU, 4 GB, 80 GB NVMe, Ubuntu 24.04), con CouchDB cerrada desde el inicio.<br>2. Corte S5 en el ambiente actual.<br>3. Stripe en modo real: claves, webhook y precios confirmados.<br>4. Publicar la versión Web (WASM) en `buscobien.net` desde el servidor de producción: nginx con HTTPS y encabezados de caché que hagan llegar cada versión nueva.<br>5. Publicar los textos legales en la Web.<br>6. Beta cerrada con 5 a 10 promotores: catálogo, captura, publicación, rotación de publicaciones, verificación de identidad, un cargo real de importe pequeño y su reembolso.<br>7. Runbook de cobro: cierre, autorización, reintentos, reembolsos, contracargos, revisión de fundadores y CFDI manual.<br>8. Monitoreo de las tareas programadas y alerta si un cierre o la revisión de condiciones no corre. |
| **Entregables** | Producción operando; reporte de la beta; runbook de cobro |
| **Dependencias** | F1 a F6 |

#### F8 · Operación de las olas (marzo a mayo de 2027)

- Revisión semanal de los indicadores de la sección 9, de las condiciones de entrada pendientes y de los huecos de publicación.
- Primer cierre real el 1 de abril, con autorización manual; igual el 1 de mayo y el 1 de junio. Desde ahí, `COBRO_AUTOMATICO=true` si no hubo diferencias.
- CFDI automatizado con un PAC (L20), Web Push con FCM para los avisos, carga de fotos por el API.
- Evaluar las apps de Android, iOS y Windows, con las reglas de pago de cada tienda.
- Retomar el plan «Mi Asistente IA» (conserjería, pestaña, agenda, prospectos, Telegram) como versión 2.0.

### 5.3 Condiciones para lanzar

| # | Condición | Se verifica con |
|---|---|---|
| G1 | Corte S5 hecho y producción nueva sin puertos de CouchDB abiertos | Escaneo de puertos y matriz de permisos de `scripts/s4` contra producción |
| G2 | Stripe verificado en modo real, con webhook firmado funcionando | Un cargo real y su reembolso |
| G3 | Un mes simulado completo sin diferencias entre el motor y el cálculo manual, IVA y casos de fundador incluidos | Tabla de casos de la sección 6 |
| G4 | Términos, aviso de privacidad y bases de la promoción publicados y aceptados en el registro | Revisión legal |
| G5 | Versión Web publicada en producción con HTTPS y probada en los navegadores objetivo, en escritorio y en teléfono | Recorrido de la sección 6 |
| G6 | Respaldo cifrado fuera del servidor y restauración probada | Ensayo de restauración |
| G7 | `python _documentacion/00_indice/verificar_documentacion.py` con 0 errores | Ejecución del script |

---

## 6. Pruebas y calidad

**Motor de consumo** (pruebas unitarias en buscobien-api, sin red, con el patrón actual de repositorios en memoria). Tabla de casos mínima:

| Caso | Resultado esperado |
|---|---|
| Espacio todo el mes sin publicar | Tarifa sin publicar completa, más IVA |
| Contratado a mitad de mes y publicado días después | Dos líneas proporcionales e IVA sobre el subtotal (ejemplo de la sección 4.3) |
| Publicado y despublicado el mismo día | Ese día cuenta como publicado |
| Eliminado a mitad de mes | Se cobra hasta el día de eliminación, inclusive |
| Meses de 28, 30 y 31 días | Un mes completo vale siempre la tarifa |
| Cambio de tipo a mitad de mes | Una línea por tipo |
| Fundador que cumple entrada y permanencia | $0 dentro del paquete; el excedente se cobra |
| Fundador que no cumple la entrada | Cobro normal desde el registro; si los 15 días cruzaron un cierre, línea de ajuste en el siguiente |
| Fundador que rota con un hueco menor que la tolerancia | Conserva el mes bonificado |
| Fundador con un hueco mayor que la tolerancia | Ese mes se cobra con tarifas normales; el siguiente vuelve a ser bonificado |
| Fin de la bonificación a mitad de mes | Cobro desde el día siguiente al fin |
| Anuncio Normal gratuito; cambiado a Relevante | $0; tarifa Relevante completa |
| Total menor que el mínimo de Stripe | Se acumula al mes siguiente |
| Eventos cerca de la medianoche | Se asignan al día de la Ciudad de México (sin horario de verano desde 2022) |

**Otras pruebas:**

- **Stripe:** tarjetas de prueba para cargo aprobado, rechazado y con autenticación; webhooks repetidos (idempotencia); clave de idempotencia por estado de cuenta.
- **Permisos:** ampliar la matriz de `scripts/s4` con las bases nuevas y los campos protegidos. Ningún cliente lee `buscobien_catalogo`, `buscobien_facturacion`, `buscobien_promociones` ni `buscobien_verificaciones`.
- **App:** `flutter analyze` sin advertencias nuevas; pruebas de widget del switch (incluido el diálogo de la última publicación), del formulario del catálogo y de «Mi consumo».
- **Recorrido manual en Web (WASM)** en Chrome, Edge y Safari de escritorio, y en Chrome de Android y Safari de iPhone a 360 px. Confirmar en la compilación que los navegadores sin soporte de WasmGC reciben el respaldo en JavaScript de `flutter build web --wasm`. Las otras plataformas solo deben seguir compilando.
- **Escenarios Gherkin** en `_documentacion/07_pruebas_y_calidad/gherkin_bdd_scenarios/` para catálogo, cobro, promociones y verificación.
- **Prueba de humo** de extremo a extremo `scripts/smoke_facturacion.mjs`: alta, tarjeta de prueba, contratar, publicar, cierre simulado y limpieza.

---

## 7. Documentación SDLC a actualizar

Al cambiar código, según `CLAUDE.md`, se actualiza el SDD, la Epic o la Feature del módulo y se ejecuta `verificar_documentacion.py` (0 errores).

| Documento | Cambio | Fase |
|---|---|---|
| `04_arquitectura_y_diseno/adr/registro_decisiones.md` | ADR nuevos: cobro pospago con libro de consumo propio; espacios y publicaciones gobernados por el API; catálogo en base cerrada; resguardo de documentos de identidad; promociones configurables; lanzamiento solo en Web. Usar los siguientes números libres: el plan de IA reservó ADR-011 a ADR-016 | F0 |
| `02_requerimientos/epics_ears/` | Epics nuevas `08_pantallas_tu_cuenta_mi_catalogo.md`, `08_pantallas_tu_cuenta_mis_publicaciones.md`, facturación, promociones y verificación; actualizar `08_pantallas_tu_cuenta_tus_espacios.md`, `05_provider_menus.md`, `08_pantallas_inicio.md`, `08_pantallas_propiedades.md`, `10_user_login.md` y `22_imagenes.md` | F0–F6 |
| `04_arquitectura_y_diseno/modulos_sdd/` | SDD de los módulos nuevos y de los cambiados | F1–F6 |
| `04_arquitectura_y_diseno/arquitectura_navegacion.md` | Menú nuevo de «Mi cuenta» | F3 |
| `04_arquitectura_y_diseno/contrato_api_actual.md` | Endpoints de la sección 4.8 | F1–F6 |
| `04_arquitectura_y_diseno/modelo_de_amenazas.md` | Fraude en las olas, contracargos, documentos de identidad, manipulación del consumo y de la publicación continua | F0 |
| `06_modelo_de_datos_y_bd/buscobien_databases_complete.md` e `inventario_seguridad_bases.md` | Bases nuevas, campos nuevos y permisos | F1–F6 |
| `08_operacion_guias_y_despliegue/guia_habilitar_stripe.md` | Modo `setup`, cargos fuera de sesión, eventos nuevos, tarifas v2 sin IVA | F2 |
| `08_operacion_guias_y_despliegue/runbook_operacion.md` | Cierre mensual, autorización, reintentos, reembolsos, CFDI manual, revisión de fundadores, despliegue de la versión Web | F7 |
| `07_pruebas_y_calidad/estrategia_de_pruebas_y_smoke_tests.md` | Tabla de casos del motor y prueba de humo de facturación | F2 |
| `01_planeacion_y_estrategia/plan_de_trabajo.md` y `okrs_y_lean_canvas.md` | Enlace a este plan; modelo de ingresos nuevo | F0 |
| `_planes/Hermes_Real_Estate_Core_Plan_Integracion_Mi_Asistente_IA.md` | Calendario después del lanzamiento y ajustes de la sección 4.10 | F0 |
| `CLAUDE.md` | «Fase actual de desarrollo», módulos implementados y plataforma del lanzamiento | Al cerrar cada fase |
| `buscobien-api/README.md` | Endpoints, tareas programadas y configuración | F1–F6 |

---

## 8. Riesgos y mitigaciones

| # | Riesgo | Mitigación |
|---|---|---|
| K1 | Contracargos y quejas por cargos recurrentes que el promotor no esperaba | Aviso a 3 días con acciones claras; consentimiento explícito al registrar la tarjeta; «Mi consumo» siempre visible, con IVA; reembolso ágil en el runbook |
| K2 | Un fundador que no cumple la entrada recibe un cobro alto desde su registro (el paquete tiene 52 espacios) | Avisos de los días 7 y 12 con el importe estimado; «Mi consumo» muestra lo que se cobraría; las condiciones se explican al contratar dentro del paquete y en las bases de la promoción |
| K3 | Un fundador pierde un mes por un descuido al rotar publicaciones | Tolerancia de 60 minutos; diálogo al apagar la última publicación; aviso inmediato si se queda sin publicaciones |
| K4 | Errores de cálculo en el cobro | Motor puro con tabla de casos; tres primeros cierres con autorización manual; bitácora de eventos para reconstruir cualquier importe |
| K5 | Abuso de las olas con cuentas falsas | Verificación de INE y CSF; una cuenta de fundador por RFC; revisión de las 3 propiedades por un operador |
| K6 | Espacio en disco: 60 fotos por espacio y paquetes de 52 espacios | Producción de 80 GB ampliable; la compresión que ya hace la app (`funciones_compress_image.dart`); medir el tamaño promedio en la beta; plan de almacenamiento de objetos si se rebasa el 60 % del disco |
| K7 | Flutter Web: primera carga pesada en teléfonos y fichas que los buscadores no indexan | Medir el tiempo de carga en la beta con teléfonos de gama media; si se busca tráfico orgánico, evaluar después del lanzamiento páginas públicas de fichas generadas por el servidor |
| K8 | Datos personales sensibles (INE) | Base cerrada, rol `operador`, aviso de privacidad y plazo de conservación |
| K9 | Cargos fuera de sesión que el banco rechaza o que piden autenticación | Enlace de pago, reintentos y suspensión ordenada (L7) |
| K10 | La verificación de Stripe en modo real se retrasa | Iniciarla en F0 |
| K11 | Lanzar sin el corte S5 | Es la condición G1; no hay excepción |
| K12 | El servidor actual (1 GB, sin swap) no soporta API, tareas, CouchDB, correo y la versión Web en producción | Producción nueva en F7, según el plan de seguridad |
| K13 | Consultas por rango sobre campos de texto | Campos `filtros.*` numéricos calculados por el API al publicar |

---

## 9. Indicadores del lanzamiento

Las metas son propuestas para fijar en F0.

| Indicador | Fuente | Meta propuesta |
|---|---|---|
| Socios fundadores registrados por ola | `buscobien_promociones` | A fijar por el propietario |
| Fundadores que cumplen la entrada (3 propiedades en 15 días) | `buscobien_promociones` | ≥ 60 % |
| Fundadores que mantienen la publicación continua cada mes | `buscobien_promociones` | ≥ 90 % de los activos |
| Propiedades publicadas y verificadas | `buscobien_publicados_*` | A fijar |
| Conversión catálogo → espacio → publicación | Bitácora de eventos | Seguimiento |
| Contactos por publicación (WhatsApp, correo, teléfono, chat) | Clics registrados en F4 | Seguimiento |
| Cargos aprobados al primer intento | `buscobien_facturacion` | ≥ 95 % |
| Contracargos | Stripe | Debajo del umbral que Stripe considera de riesgo |
| Fundadores que siguen pagando al terminar la bonificación | `buscobien_facturacion` | A medir desde septiembre de 2027 (fin de la Ola 1) |
| Tiempo de revisión del operador (verificación y entrada) | `buscobien_verificaciones`, `buscobien_promociones` | ≤ 1 día hábil |

---

## 10. Próximos pasos inmediatos

1. Confirmar las interpretaciones de la sección 3.2: cobro desde el registro al no cumplir la entrada, mes con hueco, tolerancia de 60 minutos, inicio de la permanencia y revisión de «propiedades reales».
2. Responder las decisiones pendientes de la sección 3.3, o aceptar las recomendaciones.
3. Confirmar la fecha de lanzamiento comercial en Web (propuesta: 1 de marzo de 2027) y fijar la fecha del corte S5.
4. Iniciar la verificación de Stripe en modo real.
5. Encargar los textos legales, con las condiciones de entrada y de permanencia.
6. Reprogramar el plan «Mi Asistente IA» para después del lanzamiento.
7. Crear los ADR y las Epics semilla en borrador y arrancar F1.

---

## Anexo A. Trazabilidad requerimiento → fase

| ID | Requerimiento | Diseño | Fase | Endpoint o pantalla principal |
|---|---|---|---|---|
| R01 | Publicación de propiedades | 4.1, 4.8 | F1 | `POST /espacios/:id/publicar` |
| R02 | Filtros avanzados | 4.7 | F4 | `inicio/` + `filtros.*` |
| R03 | Contacto por WhatsApp o correo | 4.9 | F4 | `acciones_propiedad.dart` |
| R04 | Exclusiones de la v1 | 4.10 | — | — |
| R05 | Mi Catálogo | 4.1, 4.7 | F3 | `/catalogo`, `mi_catalogo/` |
| R06 | Espacios, transferencia y 60 fotos | 4.1, 4.3 | F1–F3 | `POST /espacios`, `POST /catalogo/:id/transferir` |
| R07 | Switch y renovación automática | 4.1 | F1 | `Switch` en la ficha |
| R08 | Mis Publicaciones | 4.2 | F3 | `GET /publicaciones`, `mis_publicaciones/` |
| R09 | Menú de Mi cuenta | 4.2 | F3 | `opciones_mi_cuenta.dart` |
| R10 | Carga con Mi Asistente IA | 4.10 | Plan de IA (después del lanzamiento) | — |
| R11 | Capturar, editar y eliminar el espacio | 4.1, 4.8 | F1 | `form_update_espacio_comprado.dart`, `DELETE /espacios/:id` |
| R12 | Aviso a 3 días | 4.3 | F2 | Tarea `aviso-corte` |
| R13 | Cobro con Stripe y tarjeta guardada | 4.4 | F2 | `/facturacion/tarjeta`, tarea `cierre-mensual` |
| R14 | Tarifas sin IVA | 4.3 | F2 | `GET /tarifas` |
| R15 | Cobro proporcional a fin de mes | 4.3 | F2 | Motor de consumo |
| R16 | Olas de Socio Fundador | 4.5 | F6 | `promociones.json`, `GET /promociones/mi-beneficio` |
| R17 | Entrada en 15 días y publicación continua | 4.5, 4.6 | F5, F6 | Tarea `condicion-fundador`, `/operacion/fundadores` |
| R18 | Precios normales al terminar | 4.3, 4.5 | F2, F6 | Tarea `fin-bonificacion` |
| R19 | Anuncio Normal gratuito | 4.5 | F6 | `POST /espacios/:id/cambiar-tipo` |
| R20 | INE y CSF | 4.6 | F5 | `/verificacion`, pantalla «Operación» |
| R21 | Infraestructura y versión Web | 5.3 | F7 | Condiciones G1 a G7 |
| R22 | Interfaz MD3 | 4.9 | Todas | `antigravity_ui_rules.md` |
