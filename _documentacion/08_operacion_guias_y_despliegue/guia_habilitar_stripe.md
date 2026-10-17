# Guía: habilitar los pagos con Stripe en BuscoBien

**Creada:** 2026-10-17.  
**Para quién:** el propietario del negocio (cuenta de Stripe, precios y pruebas) y quien programe la app (sección 7).  
**Estado de BuscoBien:** el **servidor** ya está listo y desplegado en desarrollo (`buscobien-api`: [anexo L](plan_seguridad_nginx_jwt.md)); los pagos están **deshabilitados** hasta cargar las claves y los precios. La **app Flutter todavía usa el flujo anterior** (el cliente escribe los importes); su cambio está descrito en la sección 7.

> Los nombres de menús de Stripe cambian con el tiempo; si algo no coincide exactamente, busca la opción por su nombre en el buscador del panel. Las tarifas y requisitos de verificación son de Stripe y pueden cambiar: **confírmalos en su sitio** antes de decidir.

## Vista general

```
1. Cuenta de Stripe ──► 2. Claves de PRUEBA ──► 3. Webhook ──► 4. Precios y secretos en el servidor
                                                                              │
7. Cambios en la app ◄── 6. Prueba de punta a punta (tarjeta de prueba) ◄── 5. Permisos (S4)
        │
        └──► 8. Pasar a producción (verificación del negocio, claves reales, webhook real)
```

Los pasos 1–6 se hacen **sin dinero real** (modo de prueba) y se pueden completar el mismo día. El paso 8 requiere que Stripe verifique tu negocio y puede tardar días.

| Paso | Quién | Tiempo aproximado |
| :-- | :--- | :--- |
| 1–3 Cuenta, claves, webhook | Propietario | 20–30 min |
| 4–5 Precios, secretos y permisos en el servidor | Propietario (con `sudo`) | 15 min |
| 6 Prueba con tarjeta de prueba | Propietario | 10 min |
| 7 Cambios en la app | Desarrollo | 2–4 días (depende de la migración a JWT) |
| 8 Producción | Propietario | Días (verificación de Stripe) |

---

## 1. Suscribirse a Stripe

1. Entra a `stripe.com/mx` y elige **Crear cuenta** (México). Usa un correo de la empresa, por ejemplo `admin@buscobien.com`, y una contraseña única.
2. Activa la **verificación en dos pasos** de la cuenta (Configuración → Seguridad). Quien controla esta cuenta controla el dinero.
3. Verás el panel (*Dashboard*) en **modo de prueba**. Un interruptor «Modo de prueba» (o «Test mode») arriba a la derecha lo distingue del modo real. **Todo lo de esta guía hasta el paso 7 se hace en modo de prueba**: no hay costo ni cobros reales.
4. *(Puedes dejarlo para el paso 8)* Para cobrar de verdad, Stripe pedirá **activar la cuenta**: datos del negocio, representante legal con identificación oficial, RFC si aplica, descripción de lo que vendes, sitio web y una cuenta bancaria (CLABE) donde depositar. Ten esos datos a la mano.

**Decisiones de negocio que conviene tomar ya (no las toma el software):**

- **Tarifas:** consulta en `stripe.com/mx/pricing` la comisión por pago en México y cuándo se depositan los fondos.
- **Facturación (CFDI):** Stripe cobra, pero **no emite facturas fiscales mexicanas**. Si debes facturar a tus clientes, hará falta un servicio de facturación aparte y hablar con tu contador.
- **Reembolsos y disputas:** define tu política. Hoy, un reembolso o una disputa hechos en Stripe **no quitan automáticamente** los espacios ya entregados (no está implementado; ver «Limitaciones» al final).
- **Textos legales:** términos y condiciones, aviso de privacidad (Stripe procesa datos de pago y el correo del comprador) y política de reembolso, visibles antes de pagar.

## 2. Obtener las claves de API (modo de prueba)

1. Con el **modo de prueba activado**, ve a **Desarrolladores → Claves de API**.
2. Opción recomendada: **clave restringida** (menor riesgo si se filtra).
   - Pulsa **Crear clave restringida**, ponle un nombre (`buscobien-api-prueba`).
   - Da permiso de **Escritura** únicamente a **Checkout Sessions** (todo lo demás en «Ninguno»).
   - Cópiala: empieza con `rk_test_…`. Stripe la muestra **una sola vez**.
3. Alternativa: usar la **Clave secreta** estándar `sk_test_…` (da acceso a todo el modo de prueba).
4. La **clave publicable** (`pk_test_…`) **no se usa** en BuscoBien: el pago ocurre en la página alojada por Stripe (Checkout), no dentro de la app.

**Reglas de las claves:**

- Nunca las pegues en chats, correos, capturas ni en el repositorio.
- Si una clave se expone: Desarrolladores → Claves de API → **Rotar clave**, y vuelve a ejecutar el paso 4.
- Las claves de prueba (`…_test_…`) y las reales (`…_live_…`) son independientes. El script de configuración rechaza las reales salvo que se use `--produccion`.

## 3. Crear el webhook

El webhook es el aviso con el que Stripe le dice al servidor «este pago se confirmó». **Los espacios se crean solo cuando llega ese aviso** y la firma es válida.

1. Con el modo de prueba activado: **Desarrolladores → Webhooks → Añadir endpoint**.
2. **URL del endpoint:** `https://api.buscobien.net/webhooks/stripe`
3. **Eventos a escuchar** (exactamente estos cuatro):
   - `checkout.session.completed`
   - `checkout.session.async_payment_succeeded`
   - `checkout.session.async_payment_failed`
   - `checkout.session.expired`
4. Guarda y abre el endpoint creado: en **Secreto de firma** pulsa **Revelar** y copia el valor `whsec_…`.
5. Cada endpoint tiene su propio secreto; el de prueba **no sirve** para producción.

## 4. Cargar los secretos y los precios en el servidor

En tu PowerShell, conéctate y ejecuta (te pedirá la contraseña de `sudo`):

```powershell
ssh miservidor
```
```bash
bash /opt/buscobien-api/scripts/stripe_config.sh
```

El script pide **sin mostrarlos**: la clave secreta (paso 2) y el secreto del webhook (paso 3); los guarda en `/etc/buscobien-api/` con permisos `0640 root:buscobien-api`; y reinicia el servicio.

**Define los precios** (esto lo decide el negocio; el archivo de ejemplo trae importes ficticios):

```bash
sudo nano /etc/buscobien-api/precios.json
```

| Campo | Qué es |
| :--- | :--- |
| `confirmado` | Cámbialo a `true` **solo cuando los precios sean los definitivos**. Con `false` las compras siguen deshabilitadas |
| `moneda` | `mxn` |
| `iva` | Fracción: `0.16` = 16 % |
| `mesesMaximo` | Máximo de meses por compra |
| `maximoPorTipo` | Máximo de espacios de cada tipo por compra |
| `tipos.<tipo>.precioMensualCentavos` | Precio **por espacio y por mes, en centavos** enteros (100.00 MXN = `10000`). Tipos: `normales`, `destacados`, `superdestacados`, `oportunidades`, `remates` |

Después reinicia y revisa el registro:

```bash
sudo systemctl restart buscobien-api
journalctl -u buscobien-api -n 10 --no-pager
```

Si todo está bien **no** deben aparecer «Stripe no configurado» ni «Compras deshabilitadas». El total de una compra es: `precio × cantidad × meses`, más el IVA redondeado al centavo.

## 5. Aplicar los permisos de la cuenta de servicio

La cuenta del servicio necesita poder crear los espacios a nombre del comprador y guardar las compras:

```bash
bash /opt/buscobien-api/scripts/s4/paso_s4.sh
```

Pide la contraseña de administrador de CouchDB; muestra la simulación y exige escribir `SI`. Termina con `RESULTADO: TODO CORRECTO`. (Se puede deshacer con `… paso_s4.sh revertir`).

## 6. Probar de punta a punta (sin dinero real)

Mientras la app no esté adaptada (paso 7), la prueba se hace con la línea de comandos. En PowerShell:

```powershell
$api = "https://api.buscobien.net"
# 1) Iniciar sesión (usuario real de pruebas; la clave se pide sin dejarla en el historial)
$clave = Read-Host "Clave del usuario" -AsSecureString
$claveTexto = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($clave))
$cuerpo = @{ nombreusuario = "TU_USUARIO"; perfil = "Promotor"; password = $claveTexto } | ConvertTo-Json
$login = Invoke-RestMethod "$api/auth/login" -Method Post -ContentType "application/json" -Body $cuerpo
$h = @{ Authorization = "Bearer $($login.accessToken)" }
# 2) Ver los precios que usa el servidor
Invoke-RestMethod "$api/compras/precios" -Headers $h
# 3) Crear la compra (2 espacios normales por 2 meses)
$c = Invoke-RestMethod "$api/compras/checkout" -Method Post -Headers $h -ContentType "application/json" -Body '{"meses":2,"cantidades":{"normales":2}}'
$c
Start-Process $c.checkoutUrl     # abre la página de pago de Stripe
```

En la página de pago de Stripe usa una **tarjeta de prueba**:

| Caso | Tarjeta | Resultado esperado |
| :--- | :--- | :--- |
| Pago correcto | `4242 4242 4242 4242` | Compra `pagada` y espacios creados |
| Requiere autenticación 3D Secure | `4000 0025 0000 3155` | Pide autenticar y después `pagada` |
| Rechazada por fondos insuficientes | `4000 0000 0000 9995` | La compra sigue `pendiente` y puedes reintentar |

Fecha: cualquiera futura · CVC: cualquier 3 dígitos · CP: cualquiera. Correo: el tuyo.

Después de pagar, comprueba:

```powershell
Invoke-RestMethod "$api/compras/$($c.compraId)" -Headers $h        # estado: pagada, espaciosCreados: True
Invoke-RestMethod "$api/compras" -Headers $h                        # lista de tus compras
```

También verifica en **Stripe → Desarrolladores → Webhooks → tu endpoint → Entregas de eventos** que el evento aparezca con `200`. Los espacios nuevos son documentos vacíos (`activa = 0`) en las bases `buscobien_casas_comprados_*`, a nombre del usuario; aparecerán en «Tus espacios».

**Si algo falla:**

| Síntoma | Causa probable | Qué hacer |
| :--- | :--- | :--- |
| `POST /compras/checkout` responde `503 PAYMENTS_UNAVAILABLE` | Faltan la clave secreta o el secreto del webhook | Repetir el paso 4 |
| `503 PRICES_UNAVAILABLE` | `precios.json` no existe, es inválido o `confirmado` es `false` | Revisar `journalctl -u buscobien-api` (dice el motivo) |
| Stripe muestra el evento con error `400` | El secreto `whsec_…` no es el de ese endpoint (prueba/producción) | Copiar de nuevo el secreto del endpoint correcto y repetir el paso 4 |
| Stripe muestra `500` | Falló CouchDB al crear espacios | Stripe reintenta solo; revisar `journalctl`. Es seguro reintentar: no duplica |
| El pago se hizo pero la compra sigue `pendiente` | El evento aún no llegó o se entregó a otra URL | Revisar «Entregas de eventos»; reenviar el evento desde el panel |
| La compra queda `inconsistente` | El importe, la moneda, la sesión o el usuario del pago no coinciden con la compra | **No se entrega nada.** Revisar el pago en Stripe y el registro del servicio; no es un fallo normal |
| `401` al llamar a la API | Token vencido (15 min) | Volver a iniciar sesión |

## 7. Ajustes necesarios en la aplicación Flutter

> **Requisito previo:** los endpoints de compras exigen un token JWT (`Authorization: Bearer`). La app hoy llama a CouchDB con la contraseña de administrador y no tiene sesión por JWT. Antes de este paso deben estar hechos los cambios **C0 a C3** del [plan de seguridad](plan_seguridad_nginx_jwt.md) (capa HTTP única, almacén de tokens y login por `POST /auth/login`).

### 7.1 Qué cambia y por qué

Hoy el formulario deja **escribir los importes** (total por tipo, impuestos, gran total) y la referencia de pago a mano, y la app crea ella misma los espacios. Con Stripe la app solo pide **cuántos espacios y por cuántos meses**; el servidor calcula el precio, Stripe cobra y el servidor crea los espacios.

### 7.2 Archivos y tareas

| # | Archivo / zona | Cambio |
| :-- | :--- | :--- |
| A1 | `lib/08_pantallas/tu_cuenta/tus_espacios/compra_espacios/compras_api.dart` (nuevo) | Cliente de la API con el `ApiClient` (token Bearer): `precios()` → `GET /compras/precios`; `crearCheckout(meses, cantidades)` → `POST /compras/checkout` (devuelve `compraId` y `checkoutUrl`); `obtener(id)` → `GET /compras/:id`; `listar()` → `GET /compras`. Errores `{error, code}`: tratar `PAYMENTS_UNAVAILABLE` y `PRICES_UNAVAILABLE` como «pagos no disponibles por ahora» |
| A2 | `form_compra_espacios.dart` | Quitar los campos `totalEspacio*`, `impuestos`, `granTotal`, `referenciaDePago` y `medioDePago`. Dejar: **meses** (selector 1…`mesesMaximo`) y **cantidad por tipo** (0…`maximoPorTipo`). Mostrar un resumen con los precios de `GET /compras/precios` (subtotal, IVA, total) **solo informativo** («el importe final lo calcula el servidor»). Botón **«Pagar con Stripe»** con protección de doble toque (ya existe `_comprando`) |
| A3 | Misma pantalla | Al pulsar: `crearCheckout` → abrir `checkoutUrl` con `launchUrl(uri, mode: LaunchMode.externalApplication)`; en **Web** usar `webOnlyWindowName: '_self'` para pagar en la misma pestaña. Pasar a una **pantalla de espera** con el `compraId` |
| A4 | Nueva pantalla «Estado de la compra» | Consultar `GET /compras/:id` cada 3 s (máx. ≈ 5 min, con `mounted` antes de actualizar la interfaz). `pagada` → éxito, refrescar «Tus espacios» y volver. `fallida`/`expirada`/`inconsistente` → mensaje y opción de reintentar. `pendiente` tras el tiempo → «Si ya pagaste, tus espacios aparecerán en unos minutos» y botón «Revisar de nuevo» |
| A5 | Ciclo de vida de la app | En Android/iOS/Windows el pago ocurre en el navegador: al volver a la app (`WidgetsBindingObserver.didChangeAppLifecycleState` → `resumed`) consultar el estado de la compra pendiente |
| A6 | Rutas Web `/compra/exito` y `/compra/cancelada` | Stripe redirige ahí (`STRIPE_SUCCESS_URL` y `STRIPE_CANCEL_URL`, con `?compra=<id>`). Registrarlas en `app_routes.dart` y/o leerlas en `deep_link_handler.dart` (igual que `/recuperar`) para abrir la pantalla A4. En GitHub Pages hace falta el `404.html` de respaldo para que esas rutas carguen la app |
| A7 | `provider_compra_espacios.dart` | **Eliminar** `writeCompraEspaciosToCouchDB` y `creaEspacioCompradoToCouchDB` (la app ya no crea compras ni espacios) y los campos de importes del estado |
| A8 | Historial de compras (si existe) | Leer de `GET /compras` en lugar de la vista de CouchDB; mostrar `estado`, total, fecha y vencimiento. El modelo `CompraEspacio` ya tolera importes enteros |
| A9 | Android: `android/app/src/main/AndroidManifest.xml` | Para abrir enlaces https desde Android 11+, añadir `<queries><intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent></queries>` |
| A10 | Pruebas | `compras_api_test.dart` con `MockClient` (éxito, `503`, `401` con renovación), prueba de widget del formulario (total informativo, doble toque bloqueado) y de la pantalla de espera (`pagada`, `expirada`, tiempo agotado) |
| A11 | Documentación | Actualizar Epics/historias de «Tus Espacios — Compra», SDD de `tus_espacios`, inventarios y `verificar_documentacion.py` |

### 7.3 Detalles que no hay que olvidar

- **Nunca** poner claves de Stripe en la app ni en `defines.json`: la app no habla con Stripe, solo abre la URL que entrega el servidor.
- La pantalla de éxito de Stripe **no prueba el pago**: confía solo en el estado `pagada` que devuelve el servidor.
- No ofrecer «reintentar» creando otra compra mientras la anterior siga `pendiente` y vigente (≈ 30 min); mostrar primero su estado.
- Los espacios comprados llegan **vacíos** (`activa = 0`): el flujo posterior de «Tus Espacios» (capturar y publicar) no cambia.
- Plataformas: Android, iOS, Web (WASM) y Windows soportan `url_launcher`; no se agrega ningún paquete nuevo, lo que no afecta la compatibilidad WASM.

## 8. Pasar a producción

1. **Activar la cuenta de Stripe** (paso 1.4): datos del negocio, representante, cuenta bancaria. Hasta que Stripe la apruebe no se pueden cobrar pagos reales.
2. **Métodos de pago:** Configuración → Métodos de pago. Tarjetas vienen activas; OXXO, SPEI u otros requieren activarse y pueden tener requisitos adicionales. El servidor ya maneja los pagos que se confirman después (`async_payment_succeeded`).
3. **Crear en modo real** (interruptor «Modo de prueba» apagado): una **clave restringida real** (`rk_live_…`, escritura solo en «Checkout Sessions») y un **webhook real** hacia la URL de producción con los cuatro eventos del paso 3. El secreto `whsec_…` real es distinto del de prueba.
4. En el **servidor de producción** (no en el de desarrollo): `bash /opt/buscobien-api/scripts/stripe_config.sh --produccion`, `precios.json` con los precios definitivos y `confirmado: true`, y `STRIPE_SUCCESS_URL` / `STRIPE_CANCEL_URL` con el dominio real si cambia.
5. **Marca y recibos:** Configuración → Marca (logotipo y colores de la página de pago) y Configuración → Correos (recibos al cliente).
6. **Prueba real mínima:** una compra del importe más bajo, verificar `pagada` y los espacios, y **reembolsarla** desde el panel. Confirma que el depósito llegue a la cuenta bancaria.
7. **Monitoreo:** revisar periódicamente *Desarrolladores → Webhooks → Entregas de eventos* (entregas fallidas) y el registro del servicio. Activar las alertas por correo de Stripe.
8. **Respaldo del cambio:** conservar las claves de prueba y reales en un gestor de contraseñas; si una se filtra, rotarla de inmediato.

## Limitaciones actuales (para planearlas)

| Tema | Estado |
| :--- | :--- |
| Reembolsos y disputas | El servidor **no reacciona** a `charge.refunded` ni a disputas: un reembolso hecho en Stripe no desactiva los espacios. Hay que decidir la regla de negocio y añadirla |
| Vencimiento | La compra guarda `vencimiento` (fecha de compra + meses), pero **ningún proceso desactiva** todavía los espacios vencidos ni avisa de la renovación |
| Renovaciones / suscripciones | No hay cobro recurrente: cada compra es un pago único |
| Facturación fiscal (CFDI) | No incluida (ver paso 1) |
| Varias monedas | Solo la moneda de `precios.json` |
| Otros pagos en la misma cuenta de Stripe | El webhook los ignora (solo procesa sesiones con `compraId` de BuscoBien) |

## Referencia rápida de comandos

```bash
bash /opt/buscobien-api/scripts/stripe_config.sh                 # secretos de PRUEBA y reinicio
bash /opt/buscobien-api/scripts/stripe_config.sh --produccion    # secretos REALES (solo en el servidor de producción)
sudo nano /etc/buscobien-api/precios.json                        # precios (centavos) y "confirmado": true
sudo systemctl restart buscobien-api                             # aplicar cambios
journalctl -u buscobien-api -n 30 --no-pager                     # registro del servicio
bash /opt/buscobien-api/scripts/s4/paso_s4.sh                    # permisos de las bases (también "revertir")
```
