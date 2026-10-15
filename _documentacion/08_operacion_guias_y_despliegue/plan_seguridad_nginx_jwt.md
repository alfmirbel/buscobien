# Plan de seguridad: Nginx + JWT (versión ajustada para 190.92.151.34)

**Creado:** 2026-10-15, a partir del plan `Plan_instalacion_seguridad.md` (14/09/2026) y de una revisión de solo lectura del servidor y del código.  
**Estado:** **PLAN — NO EJECUTADO.** Nada de lo que describe este documento se ha instalado ni modificado en el servidor ni en la app.  
**Relación con el plan de mejoras:** desarrolla MEJ-26 (capa HTTP única), MEJ-27 (mailer) y MEJ-28 (migración a nginx + JWT) de [`plan_de_mejoras.md`](../01_planeacion_y_estrategia/plan_de_mejoras.md), y reemplaza a ADR-006 cuando se complete ([`registro_decisiones.md`](../04_arquitectura_y_diseno/adr/registro_decisiones.md)).  
**Regla del proyecto:** antes de tocar CouchDB en producción se hace respaldo, y los cambios grandes en el servidor se ejecutan fase por fase con confirmación.

> **Qué cambia respecto al plan original, en una línea:** el plan original asume otro servidor (Ubuntu 22.04 en una IP de VPN, con n8n y Qdrant), un dominio que no apunta a este servidor y usuarios que viven en la tabla `_users` de CouchDB. Nada de eso es cierto aquí. Además tenía errores de sintaxis, un paso que dejaría sin acceso SSH al servidor y una configuración de JWT que CouchDB no aceptaría. Las correcciones están en la sección 3.

---

## 1. Resumen y arquitectura objetivo

```
Internet
   │  HTTPS 443 (única entrada pública)
   ▼
nginx  ── TLS (Let's Encrypt), CORS, límites de peticiones, tamaño de cuerpo
   ├── /auth/*      → buscobien-api (Node, 127.0.0.1:3000)   emite y renueva JWT
   ├── /usuarios/*  → buscobien-api                          datos públicos de usuarios
   ├── /db/*        → CouchDB (127.0.0.1:5984)               valida el JWT de forma nativa
   └── /mailer/*    → buscobien-mailer (127.0.0.1:3001)      solo con clave entre servicios
```

Tres capas, en este orden de dependencia:

1. **Entrada segura:** nginx + certificado + dominio de API.
2. **Identidad:** servicio de autenticación (`buscobien-api`) que verifica la contraseña contra las bases de usuarios de BuscoBien y firma JWT (RS256); CouchDB valida esos JWT con la llave pública.
3. **Autorización y cierre:** permisos por base (`_security`), validación de escritura por propietario, y cierre de los puertos 5984, 6984 y 3001.

La migración se hace **sin interrumpir la app actual** hasta el paso de corte (fase S5): mientras CouchDB siga aceptando Basic auth de administrador, las versiones instaladas de la app siguen funcionando.

---

## 2. Estado verificado del servidor (2026-10-15, solo lectura)

| Elemento | Hallazgo |
| :--- | :--- |
| Sistema | Ubuntu **20.04.6** LTS (kernel 5.4.0, contenedor Virtuozzo/ploop), 1 GB de RAM (≈850 MB disponibles), 20 GB de disco (26 % usado). La «swap» configurada es `/dev/null`: **en la práctica no hay swap** |
| Acceso | SSH por el puerto **7822**; el usuario `deploy` está en el grupo `sudo` pero **`sudo` pide contraseña** (no se puede ejecutar de forma no interactiva) |
| Servidor web | **Apache 2.4.41** solo en el puerto 80 (sin SSL activado; `ports.conf` declara 443 pero el puerto está cerrado). Sirve una página de relleno y hace `ProxyPass /api/mailer → localhost:3001/api` |
| nginx / certbot | **No instalados** |
| CouchDB | 3.5.0 en `/opt/couchdb`; **HTTP en 5984 y HTTPS en 6984, ambos en `0.0.0.0` y abiertos a Internet** (comprobado desde fuera). Certificado de pago (cadena GoDaddy) en `/opt/couchdb/etc/` |
| Mailer | `buscobien-mailer` en pm2 (Node 18.20.8), escucha en `*:3001`, **también abierto a Internet** (se salta Apache) |
| Firewall | `ufw` activo; no se pudieron leer las reglas sin `sudo` |
| Respaldos | No hay directorio de respaldos de CouchDB ni `crontab` para `deploy` |
| DNS | `citigov.cloud → 190.92.151.34`. **`buscobien.net → 185.199.108–111.153` (GitHub Pages, no este servidor).** `api.buscobien.com` no existe. `buscobien.com` apunta a otras IP |
| Web de la app | `https://buscobien.net/` responde `200` desde **GitHub.com**. `https://buscobien.net/recuperar?token=…` responde **`404`** (falta el *fallback* de SPA: ver sección 6, S0) |

### Hallazgos de seguridad que ya existen (independientes de este plan)

| # | Hallazgo | Acción propuesta |
| :-- | :--- | :--- |
| H1 | `/opt/couchdb/etc/local.ini` tiene permisos `644` (legible por cualquier usuario local) y, en su sección `[admins]`, una **contraseña de administrador en texto plano** (no se reproduce aquí). No se pudo comprobar si esa entrada es la vigente o un resto de `local.d/10-admins.ini` | Rotar la contraseña de administrador, dejar solo el hash, `chmod 640` |
| H2 | La contraseña apareció en la salida de la revisión de esta sesión | Rotarla de todos modos (ver S1) |
| H3 | CouchDB en HTTP plano (5984) abierto a Internet | Cerrar en S5 |
| H4 | `tls_versions` incluye TLS 1.0 y 1.1 | Dejar solo 1.2/1.3 (o retirar el HTTPS nativo en S5) |
| H5 | `[cors] origins = *` con `credentials = true` | CORS se mueve a nginx con lista de orígenes |
| H6 | Mailer en 3001 abierto, sin autenticación | Escuchar en `127.0.0.1` + clave entre servicios (MEJ-27) |
| H7 | Ubuntu 20.04 sin soporte estándar | Planificar actualización a 22.04/24.04 o Ubuntu Pro (fuera de este plan, pero afecta a certbot) |

---

## 3. Revisión del plan original

| # | Problema en el plan original | Corrección |
| :-- | :--- | :--- |
| 1 | **Servidor equivocado:** destino `100.67.186.46` (IP de VPN), «Ubuntu 22.04+», incluye `n8n` y `Qdrant` | Destino `190.92.151.34`, Ubuntu 20.04. Se eliminan `n8n`/`qdrant` (no existen en este servidor) |
| 2 | **Dominios inconsistentes:** mezcla `buscobien.net`, `buscobien.com` y `api.buscobien.com`; este último no tiene DNS y los otros dos no apuntan al servidor | Decisión D1: dominio de la API (por defecto `api.buscobien.net`; alternativa `citigov.cloud`) |
| 3 | **Bloqueo de SSH:** `ufw allow OpenSSH` abre el puerto 22, pero SSH está en el **7822**; `ufw enable` dejaría la máquina sin acceso | Se permite `7822/tcp` **antes** de cualquier cambio y se revisan las reglas existentes |
| 4 | **Apache ocupa el puerto 80:** nginx no puede arrancar | Se detiene Apache y su `ProxyPass` del mailer pasa a nginx |
| 5 | **Los usuarios no están en CouchDB `_users`:** `POST /_session` solo valida usuarios de CouchDB. En BuscoBien viven en `buscobien_usuarios` y `buscobien_usuarios_promotores` (campo `usuario.claveacceso`) | El servicio de autenticación lee esas bases con una cuenta de servicio y valida la contraseña (sección 5) |
| 6 | **Manejador de JWT mal nombrado:** `{chttpd_auth, jwt_auth}` no existe; sustituir la lista deja sin `default_authentication_handler` (Basic) a la app actual | `authentication_handlers = {chttpd_auth, cookie_authentication_handler}, {chttpd_auth, jwt_authentication_handler}, {chttpd_auth, default_authentication_handler}` |
| 7 | **Claims incorrectos:** CouchDB toma el nombre de `sub` y los roles de `_couchdb.roles`, no de `roles`; el token no lleva `kid`, y `[jwt_keys]` necesita `rsa:<kid>` | El token usa `keyid: 'buscobien-1'` y `_couchdb.roles`; la llave va en **una sola línea** con `\n` |
| 8 | **Código del servicio corrupto:** faltan operadores (`\|\|`, `*`) y el nombre de la llave está truncado (`fs.rea...em`); en la configuración de nginx `(.)` debía ser `(.*)` y la zona de límite se llama `buscobien_limit` pero se usa `buscoboen_limit` | Versión corregida en el anexo A |
| 9 | **Token de 24 h sin renovación ni revocación** | Token de acceso de 15 min + token de renovación rotatorio (secciones 5 y 6) |
| 10 | **Fuerza bruta:** el login comparte el límite general | Zona propia para `/auth/` (p. ej. 5 peticiones/min por IP) y bloqueo por usuario |
| 11 | **`.env` con permisos `644`** y datos de acceso de CouchDB | `600`, propiedad del usuario del servicio; la cuenta de servicio no es administrador |
| 12 | **Usuarios y rutas inconsistentes** (`auth-user` vs `auth-service`, `npm` con `sudo`, llaves generadas como el usuario y movidas después) | Un solo usuario `buscobien-api`, llaves en `/etc/buscobien-api/` (`root:buscobien-api 0640` la privada), `npm ci` sin `sudo` |
| 13 | **CORS en CouchDB y en nginx a la vez** produce cabeceras duplicadas | CORS solo en nginx; `enable_cors = false` en CouchDB |
| 14 | **`bind_address = 127.0.0.1` no cierra el HTTPS nativo (6984)** y rompe a la app actual al instante | Se hace en S5, junto con el corte, y se deshabilita `[ssl] enable` |
| 15 | **Cuerpo máximo de nginx = 1 MB:** las fotos (base64) y avatares se rechazarían con `413` | `client_max_body_size 20m` en `/db/` |
| 16 | **Feed `_changes` (chat en vivo):** nginx cortaría la conexión por *buffering* y tiempo de espera | Ubicación dedicada con `proxy_buffering off` y `proxy_read_timeout 75s` |
| 17 | **Cabeceras COOP/COEP** innecesarias para Flutter WASM en la mayoría de los casos; con `require-corp`/`credentialless` pueden romper Google Maps y las imágenes externas | Se omiten; solo se añaden si una prueba demuestra que hacen falta |
| 18 | **Rate limit esperado = 503** | `limit_req_status 429` |
| 19 | **Copia de la llave privada en el mismo servidor** no protege nada | Respaldo cifrado fuera del servidor (S6) |
| 20 | **Despliegue de la web en este servidor (`scp -r build/web/`)** crea un directorio anidado y duplica lo que ya hace GitHub Pages | Decisión D2: la web sigue en GitHub Pages; solo se corrige el *fallback* de `/recuperar` |
| 21 | **Faltan:** respaldo previo de CouchDB, instancia de pruebas, reversión por fase, compatibilidad con versiones antiguas de la app, permisos por base y escritura por propietario, rotación de la contraseña de administrador | Incluidos en las secciones 5–8 |
| 22 | **Pruebas con `curl` y `password: ""`** (contraseña vacía en los ejemplos) | Las pruebas usan una cuenta de prueba y variables de entorno |

---

## 4. Decisiones pendientes (necesito tu respuesta antes de ejecutar)

| ID | Decisión | Recomendación |
| :-- | :--- | :--- |
| D1 | **Dominio de la API.** Opción A: `api.buscobien.net` (hay que crear un registro `A` en el DNS de `buscobien.net` apuntando a 190.92.151.34). Opción B: `citigov.cloud` (ya apunta al servidor; no requiere cambios de DNS pero mezcla la marca con otro dominio) | A, con B como plan de contingencia |
| D2 | **Dónde vive la web.** Seguir en GitHub Pages (`buscobien.net`) o moverla a nginx | Seguir en GitHub Pages: ahorra RAM y trabajo. Solo se añade `404.html` (copia de `index.html`) para que `/recuperar` cargue la app |
| D3 | **Quién ejecuta los comandos con `sudo`.** No puedo introducir la contraseña de `sudo` | Yo preparo scripts por fase en `~/seguridad/`; tú los ejecutas con `sudo` y me pasas la salida |
| D4 | **Modelo de autorización.** Opción 1: la app sigue hablando con CouchDB (vía `/db/`) con permisos por base y validación de escritura. Opción 2: crear un API REST completo por funcionalidad | Opción 1 ahora (menos cambios en la app); mover a Opción 2 lo que resulte sensible (usuarios, compras) |
| D5 | **Soporte de versiones antiguas de la app.** Fecha de corte del acceso directo a CouchDB | Publicar la versión nueva, mantener ambas 30 días y luego cerrar (S5) |
| D6 | **Actualización del sistema operativo** (20.04) | Ubuntu Pro o migración; no bloquea este plan, pero conviene antes de producción |

---

## 5. Diseño de autenticación y autorización

### 5.1 Identidad (servicio `buscobien-api`)

- Verifica credenciales contra `buscobien_usuarios` o `buscobien_usuarios_promotores` según el perfil, usando la vista `DDUSER/vistaIdUserPassByNAME`.
- **Hoy la contraseña se guarda como SHA-256 sin sal** (`generateSHA256Hash`) y la compara el cliente. El servicio:
  1. recibe la contraseña por TLS, calcula el SHA-256 y compara con `usuario.claveacceso` (compatibilidad);
  2. si coincide, la **vuelve a guardar con bcrypt** (`bcryptjs`, JS puro: sin compilar en 1 GB de RAM) en un campo nuevo y deja de usar el SHA-256;
  3. a partir de ahí solo valida con bcrypt.
- Emite:
  - **Token de acceso** RS256, 15 min, `sub = userId`, `_couchdb.roles = ["usuario"]` o `["promotor"]`, `iss`, `exp`, cabecera `kid`.
  - **Token de renovación** opaco (aleatorio), guardado con hash en una base `buscobien_sesiones`, rotatorio (cada uso emite uno nuevo) y revocable (cierre de sesión, cambio de contraseña).
- Registro, recuperación y cambio de contraseña pasan al servidor (hoy `generate_reset_token` y las escrituras de `reset_token` las hace el cliente con credenciales de administrador).
- El servicio usa una **cuenta de servicio de CouchDB** (no administradora) con acceso solo a las bases de usuarios y sesiones.

### 5.2 Autorización en CouchDB

| Capa | Qué hace |
| :--- | :--- |
| `_security` de cada base | `members.roles = ["usuario","promotor"]` en las bases que la app necesita; `admins` vacío salvo el administrador real |
| Bases de usuarios (`buscobien_usuarios`, `buscobien_usuarios_promotores`) | **Solo la cuenta de servicio.** La app no las lee directo: usa `GET /usuarios/me` y `GET /usuarios/buscar?q=` (solo campos públicos) |
| `validate_doc_update` por base | Una escritura solo se acepta si el propietario del documento coincide con `userCtx.name` (o el rol es administrador). Ejemplo en el anexo D. Requiere confirmar el campo de propietario en cada base (`idusuario`, `senderId`, `creadorId`…) |
| Lecturas | Públicas para el catálogo de propiedades (`buscobien_espacios`, fotos) con JWT válido; privadas para mensajes, listas e invitaciones, con consultas que filtran por el `sub` del token (`_find` con selector forzado desde un *design doc* o endpoint dedicado) |
| `_all_dbs`, `_users`, `_config`, `_replicate` | Solo administrador; nginx además **no expone** `/_config`, `/_node`, `/_utils` ni `/_replicate` (lista blanca de rutas) |

**Límite honesto de este diseño:** CouchDB decide permisos por base, no por documento; la protección por documento depende de `validate_doc_update` y de que las lecturas sensibles pasen por consultas filtradas. Las bases con datos privados (mensajes, listas compartidas) son las primeras candidatas a pasar a endpoints propios si la lista de reglas se vuelve difícil de mantener.

---

## 6. Plan de instalación por fases

Cada fase tiene **verificación** y **reversión**. Ninguna fase interrumpe a la app actual hasta S5.

### S0 — Preparación (sin cambios en producción) · ≈ 1 h

1. **Respaldo completo de CouchDB** (obligatorio antes de continuar): copia de `/opt/couchdb/data` con el servicio detenido en una ventana corta, o exportación por base con `_all_docs?include_docs=true&attachments=true` (ver [`runbook_operacion.md`](runbook_operacion.md) §2). Descargar el respaldo fuera del servidor.
2. Registrar el estado inicial (para reversión): `sudo ufw status numbered`, `ss -tlnp`, copia de `/opt/couchdb/etc/local.ini` y `local.d/`, `/etc/apache2/sites-enabled/000-default.conf`.
3. **Decidir D1–D6.** Crear el registro DNS `api.buscobien.net → 190.92.151.34` y esperar a que resuelva (`Resolve-DnsName`).
4. **Corregir `/recuperar` en GitHub Pages:** al publicar la web, copiar `build/web/index.html` a `404.html` (y usar `<base href="/">`). Verificar que `https://buscobien.net/recuperar?token=x&perfil=Usuario` cargue la app.
5. **Instancia de pruebas de CouchDB** (misma versión 3.5.0, puerto 5985, directorio de datos aparte, `127.0.0.1`) para validar la configuración de JWT sin tocar producción. Se apaga al terminar (consume ≈ 100 MB).
6. **Memoria:** con 1 GB y sin swap, comprobar si el contenedor permite un archivo de swap (`fallocate -l 1G /swapfile`); si no, vigilar `free -m` en cada fase.

**Reversión:** nada que revertir (solo lectura y DNS).

### S1 — Rotación de la credencial de administrador · ≈ 15 min

1. Generar una contraseña nueva (gestor de contraseñas), cambiarla por la API de CouchDB (`PUT /_node/_local/_config/admins/admin`) para que se guarde **hasheada**.
2. Limpiar la entrada en texto plano de `local.ini` y fijar `chmod 640 /opt/couchdb/etc/local.ini`.
3. Actualizar `defines.json`, `api/.env` y el `.env` del mailer. **Las versiones instaladas de la app dejarán de funcionar si usan la contraseña vieja:** hacer este paso en la ventana de corte (S5) o publicar antes una versión con la contraseña nueva.

**Verificación:** `curl -u admin:… https://citigov.cloud:6984/` → 200; con la contraseña antigua → 401.  
**Reversión:** restaurar el valor anterior en la API de configuración.

> Si no se puede aceptar el riesgo mientras llega S5, rotar ahora y publicar una versión de emergencia de la app. Es una decisión tuya (ver riesgos).

### S2 — nginx, TLS y firewall · ≈ 45 min

1. **Firewall primero:** `sudo ufw allow 7822/tcp` y revisar `ufw status`; no habilitar ni recargar nada sin que el puerto de SSH esté permitido.
2. `sudo systemctl disable --now apache2` (guardar su configuración); `sudo apt install -y nginx`.
3. `sudo ufw allow 80/tcp` y `sudo ufw allow 443/tcp` (el 5984, 6984 y 3001 **siguen abiertos** hasta S5).
4. Configuración de nginx (anexo B) en `/etc/nginx/sites-available/buscobien.conf`; primero solo el puerto 80 con `/.well-known/acme-challenge/` y el proxy provisional del mailer (`/api/mailer` → `127.0.0.1:3001/api`, igual que hoy).
5. Certificado: `certbot` (en Ubuntu 20.04 usar el paquete `certbot` + `python3-certbot-nginx`; si la versión es demasiado antigua, instalar con `snap` o usar `acme.sh`). `sudo certbot certonly --nginx -d api.buscobien.net`; comprobar `sudo certbot renew --dry-run`.
6. Activar el bloque HTTPS (anexo B), `sudo nginx -t && sudo systemctl reload nginx`.

**Verificación:** `curl -I https://api.buscobien.net/db/` responde desde nginx; `curl http://api.buscobien.net/` redirige a HTTPS; el mailer sigue respondiendo en `/api/mailer`; SSH sigue funcionando desde otra ventana **antes** de cerrar la sesión actual.  
**Reversión:** `sudo systemctl disable --now nginx && sudo systemctl enable --now apache2`; las reglas de `ufw` añadidas no estorban.

### S3 — Servicio de autenticación y JWT en CouchDB · ≈ 2 h (incluye código)

1. Crear el usuario del sistema `buscobien-api` (`--system --no-create-home --shell /usr/sbin/nologin`) y los directorios `/opt/buscobien-api` y `/etc/buscobien-api`.
2. Generar el par RSA (`openssl genrsa -out private.pem 3072` y `openssl rsa -pubout`); privada `root:buscobien-api 0640`, pública `0644`. **No copiar la privada a ningún repositorio.**
3. **Probar primero en la instancia de pruebas (puerto 5985):** copiar el anexo C (`20-jwt.ini`), generar un token de prueba y comprobar `GET /_session` con `Authorization: Bearer …` → `userCtx.name` = `sub` y `roles` correctos. Verificar aquí las dos cosas que el plan original daba por supuestas: el nombre del *claim* de roles (`_couchdb.roles`) y el comportamiento de `kid`.
4. Crear en producción: la cuenta de servicio de CouchDB (no administradora), la base `buscobien_sesiones` y los `_security` de las bases de usuarios (solo cuenta de servicio).
5. Aplicar `20-jwt.ini` en `/opt/couchdb/etc/local.d/` y reiniciar CouchDB. Gracias al orden de los manejadores (cookie → JWT → Basic) **la app actual sigue funcionando**.
6. Desplegar `buscobien-api` (anexo A) con `systemd` endurecido (anexo A.3); escucha solo en `127.0.0.1:3000`.
7. Pasar el mailer a `127.0.0.1` y exigirle una clave entre servicios (MEJ-27); que `buscobien-api` lo llame para la recuperación de contraseña.

**Verificación:** `POST /auth/login` con una cuenta de prueba devuelve token de acceso y de renovación; `GET /db/_session` con el token devuelve el usuario esperado; un token expirado o con firma distinta devuelve 401; el login erróneo repetido devuelve 429.  
**Reversión:** quitar `20-jwt.ini` y reiniciar CouchDB; `systemctl disable --now buscobien-api`.

### S4 — Permisos por base y validación de escritura · ≈ 3–4 h (depende del inventario de bases)

1. Para cada una de las bases de [`bases_de_datos_en_codigo.md`](../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md): fijar `_security` y decidir si necesita `validate_doc_update` (anexo D).
2. **Aplicar primero con `members` ampliado y probar con la app nueva en el entorno de pruebas** (S3); solo después restringir en producción base por base.
3. Subir los *design documents* al repositorio en `db/design/` (hoy no están versionados) como parte de este paso.

**Verificación:** matriz de pruebas por base (lectura con token válido / sin token / token de otro usuario; escritura propia / ajena).  
**Reversión:** restaurar el `_security` guardado por base (se exporta antes de cambiarlo).

### S5 — Corte: cerrar el acceso directo · ventana de 30–60 min

Solo después de publicar la app nueva y cumplir el plazo de D5.

1. Cambiar la contraseña de administrador (si no se hizo en S1).
2. `[chttpd] bind_address = 127.0.0.1`, `[ssl] enable = false` (retira el HTTPS 6984), `enable_cors = false`; reiniciar CouchDB.
3. `sudo ufw deny 5984/tcp`, `6984/tcp`, `3001/tcp` (o eliminar reglas existentes) y comprobar con `Test-NetConnection` desde fuera.
4. Quitar `default_authentication_handler` **solo si** ningún proceso legítimo usa Basic (el servicio de respaldo y `buscobien-api` usan una ruta local con credenciales propias).
5. Endpoint de versión mínima: las apps viejas reciben un mensaje de «actualiza la app» (ver sección 7, C8).

**Verificación:** desde Internet, 5984/6984/3001 sin respuesta; app nueva funciona completa; app vieja muestra el aviso.  
**Reversión:** revertir `bind_address` y las reglas de `ufw` (guardadas en S0).

### S6 — Operación y monitoreo · ≈ 1 h

- Rotación de logs de `buscobien-api`; `fail2ban` para `sshd` y para los 401/429 de nginx (con 1 GB de RAM, vigilar el consumo).
- Respaldo automático diario de CouchDB y de las llaves (cifrado, **fuera del servidor**) con prueba de restauración trimestral.
- Documentar la rotación de llaves JWT (publicar `rsa:buscobien-2` junto a `rsa:buscobien-1`, firmar con la nueva, retirar la vieja tras 24 h).
- Actualizar el [`runbook_operacion.md`](runbook_operacion.md), el [modelo de amenazas](../04_arquitectura_y_diseno/modelo_de_amenazas.md) (T1–T4, T5–T7), [`contrato_api_actual.md`](../04_arquitectura_y_diseno/contrato_api_actual.md) y ADR-006.

---

## 7. Plan de cambios en el código de BuscoBien

Hallazgos del código que condicionan el diseño (verificados):

- **30 archivos** de `lib/` construyen `Authorization: Basic …` con `username:password` y usan `direccionip` (CouchDB directo) en ~133 puntos de llamada.
- Las credenciales de administrador están en el binario (`--dart-define COUCHDB_USER/PASSWORD`).
- El login consulta la vista `vistaIdUserPassByNAME` (que devuelve el hash) y **compara en el cliente** (`validaPassword`); el hash SHA-256 se guarda en el dispositivo (`userPassHash`) para reautenticar.
- La recuperación de contraseña escribe `usuario.reset_token` y `usuario.claveacceso` desde el cliente (`password_recovery_repository.dart`).
- `AuthState.jwtToken` existe pero nunca se rellena.
- El chat usa `_changes` continuo (`grupos_mensajes_provider.dart` y equivalente de conocidos).
- `main.dart` ya tiene `onUnknownRoute`; `deep_link_handler.dart` maneja `/recuperar?token&perfil`.

### Cambios por etapa

| ID | Cambio | Archivos principales | Notas |
| :-- | :--- | :--- | :--- |
| C0 | **Capa HTTP única** (MEJ-26): `ApiClient` con `get/post/put/delete`, *timeout* de 10 s, `Authorization: Bearer`, manejo uniforme de errores. Debe seguir funcionando con `http.runWithClient`/`MockClient` para no romper las pruebas | `lib/40_security/api_client.dart` (nuevo) | Prerrequisito de todo lo demás. Empezar por los 3 notifiers con pruebas (conocidos, grupos, mensajes) |
| C1 | **Configuración:** reemplazar `COUCHDB_URL/USER/PASSWORD` por `API_BASE_URL` (p. ej. `https://api.buscobien.net`). Mantener un alias temporal de `direccionip` apuntando a `$API_BASE_URL/db` para migrar archivo por archivo | `lib/40_security/direccionip.dart`, `defines.json` | Quitar usuario y contraseña de `defines.json` cuando termine C4 |
| C2 | **Almacén del token:** `TokenStore` (acceso en memoria, renovación en `SessionStorage`); lectura **síncrona** para construir cabeceras sin cambiar las firmas actuales. Decodificar `exp` del JWT sin paquetes nuevos (base64) | `lib/10_user_login/usuario_login/session_storage.dart`, `provider_session.dart`, `auth_state.dart` (`jwtToken`) | Web: el almacenamiento es `shared_preferences` (legible por scripts de la página) → mantener el token de acceso corto y no guardar nada sensible más allá del token de renovación |
| C3 | **Login/registro/recuperación por la API:** `POST /auth/login`, `/auth/register`, `/auth/recover/request`, `/auth/recover/confirm`, `/auth/password`, `/auth/refresh`, `/auth/logout`. Eliminar `userPassHash` y la comparación en cliente | `login_01_login_page.dart`, `login_03_form_register_user.dart`, `session_repository.dart`, `password_recovery_repository.dart`, `page_solicitar_recuperacion.dart`, `page_cambio_password.dart` | `generate_hash.dart` y `generate_reset_token.dart` quedan sin uso (se conservan hasta retirar la compatibilidad) |
| C4 | **Cabeceras de autenticación:** sustituir los 30 constructores de `Authorization: Basic` por `ApiClient`/`authHeaders()` | los 30 archivos (`grep -rl Authorization lib`) | Mecánico; hacerlo por módulo con commit por módulo |
| C5 | **Datos de usuarios por endpoints:** reemplazar lecturas directas de `buscobien_usuarios*` (perfil, buscar usuarios para invitar, nombre/foto de contactos) por `GET /usuarios/me` y `GET /usuarios/buscar` | `session_repository.dart`, `social_providers.dart`, `grupos_invitaciones_provider.dart` (`usuariosParaInvitarProvider`, `promotoresParaInvitarProvider`), `provider_get_avatar.dart` | Evita exponer hashes y datos privados de todos los usuarios |
| C6 | **Renovación y expiración:** ante `401`, intentar `/auth/refresh` una vez; si falla, cerrar sesión y navegar al login (`navigatorKey`). Los *streams* de `_changes` deben reconectar al renovar el token (el token solo se valida al abrir la conexión) | `api_client.dart`, `grupos_mensajes_provider.dart`, `provider_mensajes.dart` | Probar con tokens de 1 min en el entorno de pruebas |
| C7 | **Mailer:** quitar la llamada directa a `http://citigov.cloud:3001/...`; la recuperación la dispara el servidor | `password_recovery_repository.dart`, `page_solicitar_recuperacion.dart` | Cierra T5–T7 |
| C8 | **Versión mínima:** `GET /auth/version` (o cabecera) → si la app es anterior al corte, mostrar «actualiza la app». Reutilizar `01_splash_screen/versiones.dart` | `splash_page.dart`, `versiones.dart` | Necesario para D5 |
| C9 | **Pruebas:** actualizar `MockClient` (ahora esperan `Bearer`), pruebas de `ApiClient` (renovación, 401, *timeout*), de `TokenStore`, de la decodificación de `exp`; mantener 0 hallazgos de `flutter analyze` | `test/*` | Los 75 tests actuales deben seguir verdes tras cada módulo |
| C10 | **Documentación:** ADR-006 → reemplazado; `arquitectura_general_buscobien.md`, `contrato_api_actual.md`, `modelo_de_amenazas.md` (T1–T4 cerrados), `SDD_10_user_login`, `SDD_40_security`, Epics de autenticación, runbook, `CLAUDE.md`/`AGENTS.md` | `_documentacion/**` | Ejecutar `verificar_documentacion.py` |

### Orden y compatibilidad

1. S0–S3 (infraestructura y servicio) sin tocar la app.
2. C0 → C1 → C2 → C3 → C4 → C5 → C6/C7 en una rama; cada commit mantiene la app compilando y las pruebas en verde. Una bandera de compilación (`--dart-define=USE_API_GATEWAY=true`) permite generar la versión nueva mientras `main` conserva el comportamiento actual.
3. Publicar la versión nueva (Web, Android, iOS, Windows). Mantener ambas versiones durante el plazo D5.
4. S4 → S5 → C8 activo.

**WASM / plataformas:** no se añaden paquetes (solo `http`, `crypto` ya existentes); no hay cambios específicos de plataforma salvo el almacén del token en Web.

---

## 8. Riesgos y mitigaciones

| Riesgo | Mitigación |
| :--- | :--- |
| Quedarse sin SSH por una regla de firewall | Permitir `7822/tcp` antes de tocar `ufw`; mantener una segunda sesión abierta; acceso de emergencia por la consola del proveedor |
| 1 GB de RAM sin swap con CouchDB + nginx + Node ×2 | Apache fuera; medir `free -m` tras cada fase; `bcryptjs` en lugar de módulos nativos; límite de memoria de `systemd` por servicio |
| JWT mal configurado en CouchDB bloquea a todos | Probar en la instancia de pruebas; coexistencia con Basic hasta S5 |
| Permisos por base demasiado estrictos rompen funciones de la app | S4 con matriz de pruebas y aplicación gradual; reversión por base |
| Datos privados expuestos por lecturas amplias (mensajes, listas) | Consultas filtradas por `sub`; candidatos a endpoints propios (D4) |
| Versiones antiguas de la app dejan de funcionar al corte | D5 + C8; comunicación previa a los usuarios |
| Let's Encrypt en Ubuntu 20.04 (certbot antiguo) | `snap`/`acme.sh` como alternativa; D6 |
| El token de Web en `shared_preferences` es robable por XSS | Token de acceso de 15 min; CSP en la web; renovación rotatoria con revocación |
| Contraseñas hoy en SHA-256 sin sal | Migración transparente a bcrypt en el primer login (sección 5.1) |

---

## 9. Checklist final

- [ ] Respaldo de CouchDB descargado y restauración probada
- [ ] Contraseña de administrador rotada y `local.ini` con permisos `640`
- [ ] DNS de la API resuelve a 190.92.151.34; certificado válido y renovación probada
- [ ] nginx activo; Apache deshabilitado; SSH sigue accesible en 7822
- [ ] JWT verificado en la instancia de pruebas y en producción (`/db/_session`)
- [ ] Login, renovación, cierre de sesión y recuperación de contraseña de punta a punta
- [ ] `_security` y `validate_doc_update` aplicados con matriz de pruebas
- [ ] App nueva publicada; plazo D5 cumplido
- [ ] 5984, 6984 y 3001 cerrados (comprobado desde fuera); CouchDB y mailer en `127.0.0.1`
- [ ] `/recuperar` carga la app en `https://buscobien.net`
- [ ] Respaldos automáticos y rotación de llaves documentados
- [ ] Documentación actualizada y `verificar_documentacion.py` en 0 errores

---

## Anexos (plantillas; validar en la instancia de pruebas antes de usarlas)

### A. Servicio `buscobien-api` (esqueleto corregido)

**A.1 `server.js` (fragmento de login)**

```javascript
import express from 'express';
import jwt from 'jsonwebtoken';
import fs from 'node:fs';
import crypto from 'node:crypto';
import bcrypt from 'bcryptjs';

const PRIVATE_KEY = fs.readFileSync('/etc/buscobien-api/private.pem', 'utf8');
const COUCHDB_URL = process.env.COUCHDB_URL ?? 'http://127.0.0.1:5984';
const KID = 'buscobien-1';
const ACCESS_TTL_S = 15 * 60;

const app = express();
app.use(express.json({ limit: '10kb' }));

app.post('/auth/login', async (req, res) => {
  const { username, password, perfil } = req.body ?? {};
  if (!username || !password) return res.status(400).json({ error: 'Datos incompletos', code: 'BAD_REQUEST' });
  try {
    const usuario = await buscarUsuario(username, perfil); // vista vistaIdUserPassByNAME con la cuenta de servicio
    if (!usuario || !(await verificarYMigrar(usuario, password))) {
      return res.status(401).json({ error: 'Credenciales inválidas', code: 'INVALID_CREDENTIALS' });
    }
    const roles = [perfil === 'Promotor' ? 'promotor' : 'usuario'];
    const accessToken = jwt.sign(
      { sub: usuario.userId, 'iss': 'buscobien', '_couchdb.roles': roles },
      PRIVATE_KEY,
      { algorithm: 'RS256', keyid: KID, expiresIn: ACCESS_TTL_S },
    );
    const refreshToken = await crearRefresh(usuario.userId, roles); // aleatorio; se guarda su hash
    res.json({ accessToken, refreshToken, expiresIn: ACCESS_TTL_S, user: { id: usuario.userId, nombre: usuario.userName } });
  } catch (e) {
    console.error('login fallido:', e.message);
    res.status(500).json({ error: 'Error interno', code: 'INTERNAL' });
  }
});

app.listen(process.env.PORT ?? 3000, '127.0.0.1');
```

Funciones por implementar: `buscarUsuario`, `verificarYMigrar` (SHA-256 heredado → bcrypt), `crearRefresh`/rotación, `/auth/register`, `/auth/recover/*`, `/auth/password`, `/usuarios/me`, `/usuarios/buscar`. Las respuestas de error siguen la convención del proyecto `{ error, code }`.

**A.2 `.env`** (`chmod 600`, propietario `buscobien-api`; **la contraseña de la cuenta de servicio no va en el repositorio**)

```
PORT=3000
NODE_ENV=production
COUCHDB_URL=http://127.0.0.1:5984
COUCHDB_SERVICE_USER=buscobien_api
COUCHDB_SERVICE_PASSWORD=<en el servidor>
MAILER_URL=http://127.0.0.1:3001
MAILER_KEY=<clave compartida>
```

**A.3 `buscobien-api.service`**

```ini
[Unit]
Description=BuscoBien API (autenticación y usuarios)
After=network.target couchdb.service

[Service]
User=buscobien-api
WorkingDirectory=/opt/buscobien-api
EnvironmentFile=/opt/buscobien-api/.env
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=5
MemoryMax=150M
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
ReadOnlyPaths=/etc/buscobien-api

[Install]
WantedBy=multi-user.target
```

### B. nginx (`/etc/nginx/sites-available/buscobien.conf`)

```nginx
limit_req_zone $binary_remote_addr zone=auth_limit:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api_limit:10m  rate=20r/s;
limit_req_status 429;

map $http_origin $cors_origin {
    default                      "";
    "https://buscobien.net"      $http_origin;
    "https://www.buscobien.net"  $http_origin;
    "http://localhost:5000"      $http_origin;   # desarrollo web; quitar en producción
}

server {
    listen 80;
    server_name api.buscobien.net;
    location /.well-known/acme-challenge/ { root /var/www/letsencrypt; }
    location / { return 301 https://$host$request_uri; }
}

server {
    listen 443 ssl http2;
    server_name api.buscobien.net;

    ssl_certificate     /etc/letsencrypt/live/api.buscobien.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.buscobien.net/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers off;

    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Access-Control-Allow-Origin $cors_origin always;
    add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
    add_header Vary Origin always;

    if ($request_method = OPTIONS) { return 204; }

    # Autenticación y usuarios
    location /auth/ {
        limit_req zone=auth_limit burst=10 nodelay;
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto https;
    }
    location /usuarios/ {
        limit_req zone=api_limit burst=40 nodelay;
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

    # Feed continuo del chat
    location ~ ^/db/[^/]+/_changes$ {
        rewrite ^/db/(.*)$ /$1 break;
        proxy_pass http://127.0.0.1:5984;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_buffering off;
        proxy_read_timeout 75s;
    }

    # Lista blanca: bloquear rutas administrativas
    location ~ ^/db/(_config|_node|_utils|_replicate|_users|_cluster_setup|_dbs_info|_all_dbs) { return 403; }

    # CouchDB con JWT nativo
    location /db/ {
        limit_req zone=api_limit burst=60 nodelay;
        client_max_body_size 20m;
        rewrite ^/db/(.*)$ /$1 break;
        proxy_pass http://127.0.0.1:5984;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Authorization $http_authorization;
    }

    # Mailer (transitorio: solo para versiones antiguas; retirar en S5)
    location /api/mailer {
        proxy_pass http://127.0.0.1:3001/api;
    }
}
```

### C. CouchDB (`/opt/couchdb/etc/local.d/20-jwt.ini`)

```ini
[chttpd]
authentication_handlers = {chttpd_auth, cookie_authentication_handler}, {chttpd_auth, jwt_authentication_handler}, {chttpd_auth, default_authentication_handler}

[jwt_auth]
required_claims = exp

[jwt_keys]
; la llave pública va en UNA línea, con los saltos de línea escritos como \n
rsa:buscobien-1 = -----BEGIN PUBLIC KEY-----\nMIIB...\n-----END PUBLIC KEY-----\n
```

Validar en la instancia de pruebas: nombre exacto del *claim* de roles (`_couchdb.roles`), exigir el emisor (`iss`) en `required_claims`, y el comportamiento sin `kid`.

### D. Ejemplo de `validate_doc_update` por propietario

```javascript
function (newDoc, oldDoc, userCtx, secObj) {
  var admin = userCtx.roles.indexOf('_admin') !== -1;
  if (admin) return;
  if (!userCtx.name) throw({ unauthorized: 'Inicia sesión' });
  var dueño = (oldDoc && oldDoc.idusuario) || newDoc.idusuario; // adaptar el campo a cada base
  if (dueño !== userCtx.name) throw({ forbidden: 'Solo el propietario puede modificar este documento' });
}
```

El campo de propietario cambia de una base a otra (`idusuario`, `senderId`, `creadorId`…); se debe confirmar en el modelo de cada una antes de aplicarlo.
