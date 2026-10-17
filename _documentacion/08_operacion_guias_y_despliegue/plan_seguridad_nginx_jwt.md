# Plan de seguridad: Nginx + JWT (versión ajustada para 190.92.151.34)

**Creado:** 2026-10-15, a partir del plan `Plan_instalacion_seguridad.md` (14/09/2026) y de una revisión de solo lectura del servidor y del código.  
**Estado:** **PLAN CON DECISIONES TOMADAS (2026-10-15).** Ejecutado hasta ahora en el ambiente de **desarrollo** (190.92.151.34): instancia de pruebas de JWT (anexo E) y nginx + certificado de `api.buscobien.net` **activos** (nginx sustituyó a Apache el 2026-10-16; anexo G). CouchDB y el mailer siguen como estaban. No se ha modificado la app.  
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
| H7 | Ubuntu 20.04 sin soporte estándar | La producción nueva usa Ubuntu 24.04 (sección 10) |
| H8 | **El mailer no puede enviar correos:** el registro de errores de pm2 muestra `535 5.7.8 Username and Password not accepted` (Gmail rechaza las credenciales SMTP). La recuperación de contraseña por correo **no funciona hoy** | Generar una contraseña de aplicación (o cambiar de proveedor SMTP) y actualizar `SMTP_*` en el `.env` del mailer; probar con la prueba de la sección 4 de [`runbook_operacion.md`](runbook_operacion.md) |

---

## 3. Revisión del plan original

| # | Problema en el plan original | Corrección |
| :-- | :--- | :--- |
| 1 | **Servidor equivocado:** destino `100.67.186.46` (IP de VPN), «Ubuntu 22.04+», incluye `n8n` y `Qdrant` | Destino `190.92.151.34`, Ubuntu 20.04. Se eliminan `n8n`/`qdrant` (no existen en este servidor) |
| 2 | **Dominios inconsistentes:** mezcla `buscobien.net`, `buscobien.com` y `api.buscobien.com`; este último no tiene DNS y los otros dos no apuntan al servidor | Decisión D1: dominio de la API (por defecto `api.buscobien.net`; alternativa `citigov.cloud`) |
| 3 | **Bloqueo de SSH:** `ufw allow OpenSSH` abre el puerto 22, pero SSH está en el **7822**; `ufw enable` dejaría la máquina sin acceso | Verificado: 7822 ya está permitido; no se tocan reglas sin confirmar que SSH sigue accesible |
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

## 4. Decisiones tomadas (2026-10-15)

| ID | Decisión | Consecuencia en el plan |
| :-- | :--- | :--- |
| D1 | **Dominio de la API: `api.buscobien.net`.** | Hay que crear el registro DNS (instrucciones en 4.1). El certificado se emite para ese nombre |
| D2 | **La web sigue en GitHub Pages.** Más adelante se moverá a un ambiente de producción nuevo | No se despliega la web en este servidor. Solo se corrige el *fallback* `404.html` para `/recuperar` y se fija CORS a `buscobien.net` |
| D3 | **Reparto de ejecución.** Lo delicado (respaldo y restauración, firewall, cierre de puertos, claves, rotación de contraseñas, actualización del sistema operativo, reinicios de CouchDB) lo ejecuta el propietario con `sudo`; **la instalación de productos y la configuración no destructiva las ejecuto yo** | Ver 4.2. `deploy` no tiene `sudo` sin contraseña; para las instalaciones se usará el alias administrativo `miservidor-root` descrito en `CLAUDE.md` (verificado: responde como `root`) |
| D4 | **Autorización por permisos de cada base + `validate_doc_update`** (sin API completa por funcionalidad) | Se mantiene el diseño de la sección 5. El servicio `buscobien-api` queda limitado a autenticación y datos públicos de usuarios |
| D5 | **Este es un ambiente de desarrollo; la producción es nueva y nace cerrada.** El acceso directo a CouchDB se cierra cuando los cambios estén operando y probados | Se **elimina** el plazo de 30 días y la compatibilidad con versiones antiguas: no hay ventana de convivencia ni endpoint de versión mínima (C8 pasa a opcional). La producción nueva se configura desde el inicio con CouchDB en `127.0.0.1`, sin 5984/6984/3001 abiertos |
| D5b | **La administración de CouchDB hoy es por `https://citigov.cloud:6984/_utils`; en producción cambiará la dirección** | Ver 4.3: la interfaz de administración deja de estar en la dirección pública |
| D6 | **Actualizar Ubuntu 20.04** | Se incluye como fase S0b antes de instalar nada (ver 4.4); es delicada y la ejecuta el propietario, con una captura (*snapshot*) previa del VPS |

### 4.1 Crear el registro DNS de `api.buscobien.net`

El DNS de `buscobien.net` lo administra **GoDaddy** (servidores `ns69/ns70.domaincontrol.com`). `api.buscobien.net` hoy **no existe**.

1. Entra a GoDaddy → *Mis productos* → `buscobien.net` → **DNS** (Administrar DNS).
2. **Agregar** un registro con estos datos:

   | Campo | Valor |
   | :--- | :--- |
   | Tipo | `A` |
   | Nombre | `api` |
   | Datos / Valor | `190.92.151.34` |
   | TTL | 600 segundos (o 1 hora) |

3. No modifiques los registros `A` existentes de `@` (los de GitHub Pages: 185.199.108–111.153) ni el `CNAME` de `www`; el nuevo registro es independiente.
4. Si existe un registro **CAA** en el dominio, debe incluir `letsencrypt.org` (si no hay ninguno, no hay que hacer nada).
5. Comprobación (PowerShell): `Resolve-DnsName api.buscobien.net -Type A` debe devolver `190.92.151.34`. Avísame cuando resuelva; Let's Encrypt lo necesita antes de emitir el certificado.

> Importante: `api` **no** debe ser un `CNAME` hacia GitHub Pages; tiene que ser un registro `A` a la IP del servidor.

### 4.2 Quién ejecuta qué

| Lo ejecuto yo (por `miservidor-root`, mostrando antes el comando) | Lo ejecutas tú (con `sudo` o desde el panel) |
| :--- | :--- |
| Lecturas de verificación; instalación de paquetes (`nginx`, `certbot`, `fail2ban`; Node 18 ya está) | Captura (*snapshot*) del VPS y descarga del respaldo de CouchDB fuera del servidor |
| Archivos de configuración de nginx, del servicio y de CouchDB **en la instancia de pruebas** | Actualización de Ubuntu (S0b) |
| Servicio `buscobien-api`, unidad `systemd`, pruebas con `curl` | Cualquier cambio de reglas de `ufw`, apertura o cierre de puertos |
| Instancia de pruebas de CouchDB (puerto 5985, solo `127.0.0.1`) | Rotación de la contraseña de administrador, generación y custodia de las llaves RSA |
| Cambios de código y documentación | Reinicios de CouchDB de producción y el corte final (S5) |

Antes de cualquier comando que modifique el servidor te muestro el comando; en los de la columna derecha, o cuando afecten a servicios en uso (Apache, CouchDB, mailer), espero tu confirmación.

### 4.3 Administración de CouchDB (Fauxton / `_utils`)

- **Hoy (desarrollo):** `https://citigov.cloud:6984/_utils/` (HTTPS nativo de CouchDB). Se mantiene mientras dure el ambiente de desarrollo y hasta el corte S5.
- **Después del corte, y en la producción nueva:** la interfaz **no se publica**. nginx devuelve `403` en `/db/_utils`, `/db/_config` y similares, y CouchDB escucha solo en `127.0.0.1`. Opciones para administrar, de la más segura a la más cómoda:
  1. **Túnel SSH (recomendada):** `ssh -p 7822 -L 5984:127.0.0.1:5984 deploy@<servidor>` y abrir `http://localhost:5984/_utils/`.
  2. Un nombre aparte (p. ej. `admin-db.<dominio>`) con TLS, **lista de IP permitidas** y la autenticación propia de CouchDB; solo si se necesita acceso sin túnel.
  3. VPN (Tailscale) limitada a la dirección de administración.
- Esto cambia el procedimiento de [`runbook_operacion.md`](runbook_operacion.md): todo acceso administrativo pasa por el túnel o la VPN.

### 4.4 Actualización de Ubuntu (S0b)

Estado verificado: Ubuntu **20.04.6** en un contenedor Virtuozzo con 1 GB de RAM y sin swap. 20.04 → **22.04** (después, si se quiere, 24.04) con `do-release-upgrade`.

Riesgos específicos de este servidor: el actualizador necesita memoria (puede quedarse corto con 1 GB), algunos proveedores de contenedores no permiten el cambio de versión, y CouchDB está instalado a mano en `/opt/couchdb` (no se actualiza con `apt`, pero depende de bibliotecas del sistema, como OpenSSL).

Condiciones previas, **todas** obligatorias:

1. Captura del VPS desde el panel del proveedor y respaldo de CouchDB descargado.
2. Confirmar con el proveedor que el contenedor admite `do-release-upgrade`.
3. Sesión SSH dentro de `screen`/`tmux` y una segunda sesión de reserva; ventana de mantenimiento.
4. Comprobar después: `couchdb` y `pm2` arrancan, SSH en 7822 responde, el mailer envía.

**Verificación del 2026-10-16:** la virtualización es **OpenVZ/Virtuozzo** (`systemd-detect-virt = openvz`; el kernel 5.4 es el del anfitrión), no está instalado `ubuntu-release-upgrader` (no existe `do-release-upgrade` ni `/etc/update-manager/release-upgrades`) y no hay paquetes pendientes (`apt list --upgradable` = 0). En este tipo de contenedores el sistema operativo suele gestionarse como una **plantilla del proveedor**; una actualización in situ puede dejar el contenedor inconsistente o no arrancar.

**Recomendación:** no actualizar este contenedor en su sitio. Hay dos caminos:

1. **Reinstalar con una plantilla Ubuntu 22.04/24.04 desde el panel del proveedor** (si la ofrece), restaurando después CouchDB desde el respaldo; o
2. **Crear la producción nueva en un servidor con Ubuntu 22.04/24.04** y aplicar este plan allí (coherente con D5 y D2). El servidor actual queda como ambiente de desarrollo en Ubuntu 20.04, con nginx y certbot en las versiones de ese sistema (nginx 1.18, certbot 0.40: funcionan con Let's Encrypt, pero sin soporte).

Si el proveedor confirma que admite `do-release-upgrade`, se puede intentar con las condiciones previas anteriores.

### 4.5 Estado del firewall (`ufw`, verificado)

Reglas abiertas hoy: 22, 21, 5984, 6984, 7822, 8443, 80, 443 y 3001 (IPv4 e IPv6). **7822 ya está permitido** (no hay riesgo de bloqueo SSH al activar nuevas reglas). Sobran 21 (FTP), 22 y 8443: no se usan según lo verificado y se proponen para cierre en S5, previa confirmación del propietario, junto con 5984, 6984 y 3001.

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
3. Registro DNS `api.buscobien.net → 190.92.151.34` (instrucciones en 4.1): **creado y verificado el 2026-10-16** (resuelve a la IP del servidor en el DNS local, en 8.8.8.8 y en los servidores de GoDaddy; TTL 3600). Las decisiones D1–D6 ya están tomadas (sección 4).
4. **Corregir `/recuperar` en GitHub Pages:** al publicar la web, copiar `build/web/index.html` a `404.html` (y usar `<base href="/">`). Verificar que `https://buscobien.net/recuperar?token=x&perfil=Usuario` cargue la app.
5. **Instancia de pruebas de CouchDB** (misma versión 3.5.0, puerto 5985, directorio de datos aparte, `127.0.0.1`) para validar la configuración de JWT sin tocar producción. Se apaga al terminar (consume ≈ 100 MB).
6. **Memoria:** con 1 GB y sin swap, comprobar si el contenedor permite un archivo de swap (`fallocate -l 1G /swapfile`); si no, vigilar `free -m` en cada fase.

**Reversión:** nada que revertir (solo lectura y DNS).

### S0b — Actualización de Ubuntu (D6) · ≈ 1–2 h, la ejecuta el propietario

Ver 4.4. Si se elige reinstalar o migrar (4.4), se hace **antes** de instalar nginx y certbot en el servidor definitivo; en el ambiente de desarrollo actual se puede instalar sobre 20.04 sin esperar. Verificación posterior: `lsb_release -ds`, `systemctl is-active couchdb apache2`, `pm2 status`, `ss -tlnp`.

### S1 — Rotación de la credencial de administrador · ≈ 15 min

1. Generar una contraseña nueva (gestor de contraseñas), cambiarla por la API de CouchDB (`PUT /_node/_local/_config/admins/admin`) para que se guarde **hasheada**.
2. Limpiar la entrada en texto plano de `local.ini` y fijar `chmod 640 /opt/couchdb/etc/local.ini`.
3. Actualizar `defines.json`, `api/.env` y el `.env` del mailer. Es un ambiente de desarrollo (D5): las compilaciones existentes con la contraseña vieja dejarán de conectar y se recompilan con el `defines.json` nuevo.

**Verificación:** `curl -u admin:… https://citigov.cloud:6984/` → 200; con la contraseña antigua → 401.  
**Reversión:** restaurar el valor anterior en la API de configuración.

> Recomendado hacerlo **al inicio**, por los hallazgos H1/H2: la contraseña actual ya quedó expuesta en una salida de revisión. La ejecuta el propietario (D3).

### S2 — nginx, TLS y firewall · ≈ 45 min (**hecho en desarrollo el 2026-10-16: nginx activo y certificado emitido; ver anexos F y G**)

1. **Firewall:** verificado que `7822/tcp`, `80/tcp` y `443/tcp` ya están permitidos (4.5); no hace falta tocar reglas en esta fase. No deshabilitar ni recargar `ufw` sin que 7822 siga permitido.
2. `sudo systemctl disable --now apache2` (guardar su configuración); `sudo apt install -y nginx`.
3. Los puertos 5984, 6984 y 3001 **siguen abiertos** hasta S5 (la app actual los usa). El 80 lo toma nginx al detener Apache.
4. Configuración de nginx (anexo B) en `/etc/nginx/sites-available/buscobien.conf`; primero solo el puerto 80 con `/.well-known/acme-challenge/` y el proxy provisional del mailer (`/api/mailer` → `127.0.0.1:3001/api`, igual que hoy).
5. Certificado: `certbot` (en Ubuntu 20.04 usar el paquete `certbot` + `python3-certbot-nginx`; si la versión es demasiado antigua, instalar con `snap` o usar `acme.sh`). `sudo certbot certonly --nginx -d api.buscobien.net`; comprobar `sudo certbot renew --dry-run`.
6. Activar el bloque HTTPS (anexo B), `sudo nginx -t && sudo systemctl reload nginx`.

**Verificación:** `curl -I https://api.buscobien.net/db/` responde desde nginx; `curl http://api.buscobien.net/` redirige a HTTPS; el mailer sigue respondiendo en `/api/mailer`; SSH sigue funcionando desde otra ventana **antes** de cerrar la sesión actual.  
**Reversión:** `sudo systemctl disable --now nginx && sudo systemctl enable --now apache2`; las reglas de `ufw` añadidas no estorban.

### S3 — Servicio de autenticación y JWT en CouchDB · ≈ 2 h (incluye código)

1. Crear el usuario del sistema `buscobien-api` (`--system --no-create-home --shell /usr/sbin/nologin`) y los directorios `/opt/buscobien-api` y `/etc/buscobien-api`.
2. Generar el par RSA (`openssl genrsa -out private.pem 3072` y `openssl rsa -pubout`); privada `root:buscobien-api 0640`, pública `0644`. **No copiar la privada a ningún repositorio.**
3. **Probar primero en la instancia de pruebas (puerto 5985): ✅ HECHO el 2026-10-16** con CouchDB 3.5.0 (resultados en el anexo E). Quedan por verificar solo los puntos que requieren nginx (anexo E, punto 5).
4. Crear en producción: la cuenta de servicio de CouchDB (no administradora), la base `buscobien_sesiones` y los `_security` de las bases de usuarios (solo cuenta de servicio).
5. Aplicar `20-jwt.ini` en `/opt/couchdb/etc/local.d/` y reiniciar CouchDB. Gracias al orden de los manejadores (cookie → JWT → Basic) **la app actual sigue funcionando**.
6. Desplegar `buscobien-api` (anexo A) con `systemd` endurecido (anexo A.3); escucha solo en `127.0.0.1:3000`.
7. Pasar el mailer a `127.0.0.1` y exigirle una clave entre servicios (MEJ-27); que `buscobien-api` lo llame para la recuperación de contraseña.

**Verificación:** `POST /auth/login` con una cuenta de prueba devuelve token de acceso y de renovación; `GET /db/_session` con el token devuelve el usuario esperado; un token expirado o con firma distinta devuelve 401; el login erróneo repetido devuelve 429.  
**Reversión:** quitar `20-jwt.ini` y reiniciar CouchDB; `systemctl disable --now buscobien-api`.

#### Cómo se construye `buscobien-api` (acciones, en orden)

| # | Acción | Quién | Depende de |
| :-- | :--- | :--- | :--- |
| 1 | Decidir dónde vive el código: el `CLAUDE.md` lo prevé en un **repositorio separado** (hoy existe `api/` vacío en este repositorio). Recomendado: repositorio propio `buscobien-api` | Propietario | — |
| 2 ✅ | Crear el proyecto (Node ESM, `express`, `jsonwebtoken`, `bcryptjs`, `nano`; estructura `src/{routes,controllers,middleware,db}`; sin dependencias nativas) con `GET /health` | Claude | 1 |
| 3 | Escribir los endpoints: `POST /auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/register`, `/auth/recover/request`, `/auth/recover/confirm`, `/auth/password`; `GET /usuarios/me`, `/usuarios/buscar` | Claude | 2 |
| 4 | Pruebas automáticas (`node:test` con CouchDB simulado): migración SHA-256 → bcrypt, rotación y revocación del token de renovación, límites de intentos, **ningún token contiene `_admin`**, respuestas `{ error, code }` | Claude | 3 |
| 5 | Rotar la contraseña de administrador de CouchDB (S1) y **crear la cuenta de servicio `buscobien_api`** (no administradora) con acceso solo a `buscobien_usuarios`, `buscobien_usuarios_promotores` y `buscobien_sesiones`; crear la base `buscobien_sesiones` | Propietario (credenciales de administrador) | S1 |
| 6 | Generar el par RSA **en el servidor** (`private.pem` `0640 root:buscobien-api`) y crear el usuario del sistema `buscobien-api` y `/etc/buscobien-api/` | Propietario | — |
| 7 | Añadir la llave pública a CouchDB (`20-jwt.ini`, anexo C) y **reiniciar CouchDB de producción** (corte de segundos; CouchDB sigue aceptando Basic de administrador, así que la app actual no se ve afectada) | Propietario | 6 |
| 8 | Desplegar el servicio (`npm ci`, `.env` con permisos `600`, unidad `systemd` del anexo A.3) escuchando solo en `127.0.0.1:3000`; nginx ya lo enruta (`/auth/`, `/usuarios/`) | Claude (instalación) | 4, 5, 6 |
| 9 | Pruebas de punta a punta contra `https://api.buscobien.net`: login con una cuenta de prueba, `/db/_session` con el token, renovación, cierre de sesión, límite de intentos | Claude | 7, 8 |
| 10 | Arreglar el SMTP del mailer (hallazgo H8) y conectar la recuperación de contraseña del servicio con él | Propietario (credencial SMTP) + Claude | 8 |

**Decisiones de diseño que conviene confirmar antes del paso 3:** vigencia del token de acceso (15 min) y del de renovación (30 días), política de contraseñas (mínimo de longitud), qué campos de un usuario son públicos en `/usuarios/buscar` (por ejemplo nombre, foto y perfil; **nunca** correo, teléfono ni hash), y si el nombre de usuario seguirá siendo el identificador de acceso.

### S4 — Permisos por base y validación de escritura · ≈ 3–4 h (depende del inventario de bases)

1. Para cada una de las bases de [`bases_de_datos_en_codigo.md`](../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md): fijar `_security` y decidir si necesita `validate_doc_update` (anexo D).
2. **Aplicar primero con `members` ampliado y probar con la app nueva en el entorno de pruebas** (S3); solo después restringir en producción base por base.
3. Subir los *design documents* al repositorio en `db/design/` (hoy no están versionados) como parte de este paso.

**Verificación:** matriz de pruebas por base (lectura con token válido / sin token / token de otro usuario; escritura propia / ajena).  
**Reversión:** restaurar el `_security` guardado por base (se exporta antes de cambiarlo).

### S5 — Corte: cerrar el acceso directo · ventana de 30–60 min

Se ejecuta cuando los cambios estén operando y probados (D5). No hay plazo de convivencia con versiones antiguas: es un ambiente de desarrollo, y la producción nueva nace ya con esta configuración.

1. Cambiar la contraseña de administrador (si no se hizo en S1).
2. `[chttpd] bind_address = 127.0.0.1`, `[ssl] enable = false` (retira el HTTPS 6984), `enable_cors = false`; reiniciar CouchDB.
3. `sudo ufw deny 5984/tcp`, `6984/tcp`, `3001/tcp` (o eliminar reglas existentes) y comprobar con `Test-NetConnection` desde fuera.
4. Quitar `default_authentication_handler` **solo si** ningún proceso legítimo usa Basic (el servicio de respaldo y `buscobien-api` usan una ruta local con credenciales propias).
5. Cerrar también 21 (FTP), 22 y 8443 si el propietario confirma que no se usan (4.5). La interfaz de CouchDB deja de ser pública (4.3).

**Verificación:** desde Internet, 5984/6984/3001 sin respuesta; la app nueva funciona completa; la administración de CouchDB funciona por túnel SSH.  
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
| C6 | **Renovación y expiración:** ante `401` (token expirado) o `400` (`Unknown kid`/`Bad signature`, verificado en el anexo E), intentar `/auth/refresh` una vez; si falla, cerrar sesión y navegar al login (`navigatorKey`). Los *streams* de `_changes` deben reconectar al renovar el token (el token solo se valida al abrir la conexión) | `api_client.dart`, `grupos_mensajes_provider.dart`, `provider_mensajes.dart` | Probar con tokens de 1 min en el entorno de pruebas |
| C7 | **Mailer:** quitar la llamada directa a `http://citigov.cloud:3001/...`; la recuperación la dispara el servidor | `password_recovery_repository.dart`, `page_solicitar_recuperacion.dart` | Cierra T5–T7 |
| C8 | *(opcional)* **Versión mínima:** `GET /auth/version` → mostrar «actualiza la app». Con D5 ya no es necesario para el corte; útil cuando haya usuarios reales en producción | `splash_page.dart`, `versiones.dart` | Diferido |
| C9 | **Pruebas:** actualizar `MockClient` (ahora esperan `Bearer`), pruebas de `ApiClient` (renovación, 401, *timeout*), de `TokenStore`, de la decodificación de `exp`; mantener 0 hallazgos de `flutter analyze` | `test/*` | Los 75 tests actuales deben seguir verdes tras cada módulo |
| C10 | **Documentación:** ADR-006 → reemplazado; `arquitectura_general_buscobien.md`, `contrato_api_actual.md`, `modelo_de_amenazas.md` (T1–T4 cerrados), `SDD_10_user_login`, `SDD_40_security`, Epics de autenticación, runbook, `CLAUDE.md`/`AGENTS.md` | `_documentacion/**` | Ejecutar `verificar_documentacion.py` |

### Orden y compatibilidad

1. S0–S3 (infraestructura y servicio) sin tocar la app.
2. C0 → C1 → C2 → C3 → C4 → C5 → C6/C7 en una rama; cada commit mantiene la app compilando y las pruebas en verde. Una bandera de compilación (`--dart-define=USE_API_GATEWAY=true`) permite generar la versión nueva mientras `main` conserva el comportamiento actual.
3. Compilar y probar la versión nueva en el ambiente de desarrollo (Web, Android, iOS, Windows).
4. S4 → S5 cuando esté probada. No hay convivencia con versiones antiguas (D5).

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
| Compilaciones antiguas dejan de conectar al corte | Aceptado (D5: ambiente de desarrollo). En producción nueva no existe el problema |
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
- [ ] App nueva probada en desarrollo (D5)
- [ ] Ubuntu actualizado (S0b) y servicios verificados
- [ ] Administración de CouchDB solo por túnel SSH o VPN
- [ ] 5984, 6984 y 3001 cerrados (comprobado desde fuera); CouchDB y mailer en `127.0.0.1`
- [ ] `/recuperar` carga la app en `https://buscobien.net`
- [ ] Respaldos automáticos y rotación de llaves documentados
- [ ] Documentación actualizada y `verificar_documentacion.py` en 0 errores

---

---

## 10. Servidor de producción nuevo (Ubuntu 24.04 LTS)

La producción es nueva (D5) y nace cerrada. Este apartado sustituye, para producción, lo que el resto del documento describe para el ambiente de desarrollo actual (Ubuntu 20.04 en OpenVZ). Las secciones 5–7 (diseño de autenticación y autorización, cambios de código) **no cambian**.

### 10.1 Características que debe tener el servidor

**Requisitos obligatorios** (sin ellos el plan no es viable o no es seguro):

| Característica | Requisito | Por qué |
| :--- | :--- | :--- |
| Virtualización | **KVM/VMware (máquina virtual completa) o servidor dedicado.** No OpenVZ/Virtuozzo ni LXC compartido | El contenedor actual no permite actualizar el sistema, no tiene swap real y limita el aislamiento de `systemd` (`ProtectSystem`, `PrivateTmp`) que usa el plan para endurecer los servicios. Con KVM además se pueden hacer capturas y recuperar el equipo desde la consola |
| Sistema operativo | **Ubuntu 24.04 LTS (Noble)** limpio, soportado hasta 2029 | nginx 1.24, OpenSSL 3, certbot 2.x y Node 22 disponibles; kernel propio |
| Acceso | `root` o usuario con `sudo` + **llave SSH** (sin contraseña); consola web/VNC del proveedor para emergencias | Reemplazar el acceso por contraseña y poder recuperarse si una regla del firewall bloquea SSH |
| Memoria | **≥ 2 GB (recomendado 4 GB)** + 2 GB de swap | CouchDB (índices de vistas y compactación) + nginx + `buscobien-api` + `buscobien-mailer` + sistema. El servidor actual (1 GB, sin swap) es el mínimo con el que corre hoy, no con el que se debe producir |
| CPU | **≥ 2 vCPU** | La indexación de vistas y la compactación de CouchDB, y bcrypt en el login, compiten con las peticiones |
| Disco | **≥ 60 GB SSD/NVMe** (los datos de CouchDB en una ruta que pueda crecer; ideal un volumen aparte) | Las fotos y avatares se guardan como base64 dentro de documentos y la compactación necesita espacio libre adicional (hasta ~2× el tamaño de la base) |
| Red | **IPv4 pública fija**; IPv6 opcional; **DNS inverso (PTR)** configurable | El PTR evita que los correos de recuperación caigan en spam |
| Puertos entrantes | **80 y 443** (público), **SSH en un puerto no estándar o restringido por IP/VPN** | Nada más: CouchDB (5984/6984), `buscobien-api` (3000) y el mailer (3001) solo en `127.0.0.1` |
| Salida a Internet | HTTPS (443) a Let's Encrypt, repositorios de `apt`/`npm`/CouchDB y servicios de notificación; **SMTP saliente (587/465) permitido** | El proveedor no debe bloquear SMTP si el mailer envía directamente; si lo bloquea hace falta un relevo de correo (p. ej. un servicio transaccional) |
| Firewall del proveedor | Grupo de seguridad/firewall en el panel, además de `ufw` | Doble barrera; permite cerrar un puerto aunque el sistema falle |
| Respaldo | **Capturas (snapshots) del proveedor** y espacio externo para copias cifradas (otro proveedor o almacenamiento de objetos) | Un respaldo en el mismo servidor no protege contra su pérdida |
| Hora | NTP activo (`chrony` o `systemd-timesyncd`) | Los JWT dependen de `exp`; un reloj desfasado invalida sesiones |
| Ubicación | Región cercana a los usuarios (México/sur de EE. UU.) | Latencia de la app móvil y de las fotos |

**Recomendables:**

| Característica | Detalle |
| :--- | :--- |
| Tamaño de partida | 2 vCPU / 4 GB RAM / 80 GB NVMe, ampliable sin reinstalar |
| Dos entornos | Un segundo servidor pequeño (o el actual) para pruebas, de modo que la producción no se use para validar configuraciones |
| Monitoreo externo | Un chequeo de disponibilidad desde fuera (HTTPS de `api.<dominio>`) y alertas de disco/memoria |
| Dominio | Subdominio dedicado a la API de producción (p. ej. `api.<dominio-de-producción>`) con DNS administrable; registro CAA opcional que autorice `letsencrypt.org` |
| Datos personales | Cifrado en reposo del volumen de respaldos y acceso restringido, por tratarse de datos personales (aviso de privacidad vigente) |
| Soporte | Contrato o canal de soporte del proveedor con tiempos de respuesta conocidos |

**Cómo comprobar un candidato antes de contratarlo:** `systemd-detect-virt` debe devolver `kvm` (o `none` en dedicado); `free -m` y `swapon --show` deben mostrar la memoria contratada y una swap real; `nc -vz smtp.<servidor-de-correo> 587` debe conectar; `lsb_release -ds` debe indicar Ubuntu 24.04.

### 10.2 Diferencias respecto al ambiente de desarrollo

| Tema | Desarrollo actual (Ubuntu 20.04, OpenVZ) | Producción (Ubuntu 24.04, KVM) |
| :--- | :--- | :--- |
| nginx | 1.18 de los repositorios de 20.04 (instalado) | 1.24 de Noble; `listen 443 ssl http2;` sigue siendo válido (en versiones ≥ 1.25.1 se prefiere `http2 on;`) |
| certbot | 0.40 (`apt`), solo con `--webroot` | `apt install certbot python3-certbot-nginx` (2.9) o `snap`; renovación con `certbot.timer` |
| Node.js | 18.20 (fin de vida) | **22 LTS** (NodeSource) o 20 LTS; servicios con `Node ≥ 20` |
| CouchDB | 3.5.0 en `/opt/couchdb` (instalación previa) | 3.5.x desde el repositorio `apt` oficial de Apache CouchDB para Noble (**verificar que exista el repositorio de la versión elegida antes de contratar**; si no, imagen Docker oficial o paquete de la última versión disponible) |
| Apache | Activo (puerto 80) | **No se instala**; nginx es el único servidor web |
| Puertos de CouchDB | 5984/6984 públicos hoy | `bind_address = 127.0.0.1` y **sin HTTPS nativo** (`[ssl] enable = false`) desde el primer arranque |
| Administración de CouchDB | `https://citigov.cloud:6984/_utils` | Túnel SSH a `127.0.0.1:5984/_utils` (4.3) |
| `systemd` | Limitado en OpenVZ | Endurecimiento completo (`ProtectSystem=strict`, `PrivateTmp`, `NoNewPrivileges`, `MemoryMax`) |
| Swap | Inexistente | Archivo/partición de 2 GB, `vm.swappiness=10` |
| Actualizaciones de seguridad | Manuales | `unattended-upgrades` activo |
| `ufw` | Reglas abiertas heredadas | Política `deny incoming`; solo 80, 443 y SSH |

### 10.3 Secuencia de construcción de la producción

Cada paso lo ejecuta quien indica la sección 4.2. No hay convivencia con versiones antiguas (D5): CouchDB nace en `127.0.0.1`.

| # | Paso | Verificación |
| :-- | :--- | :--- |
| P0 | Contratar el servidor (10.1), crear el DNS `api.<dominio>` → IP, cargar la llave SSH, probar la consola de emergencia | `ssh` con llave; `Resolve-DnsName api.<dominio>` |
| P1 | Sistema base: `apt update && apt full-upgrade`, zona horaria, `chrony`, usuario administrador sin `root` remoto, `sshd` solo con llaves (`PasswordAuthentication no`, `PermitRootLogin no`), swap de 2 GB, `unattended-upgrades` | `sshd -T | grep -E 'passwordauthentication|permitrootlogin'` |
| P2 | Firewall: `ufw default deny incoming`, permitir **primero el puerto de SSH** y después 80/443; igual en el firewall del proveedor | `ufw status`, prueba desde fuera con `Test-NetConnection` |
| P3 | CouchDB desde el repositorio oficial: **antes del primer arranque** escribir `bind_address = 127.0.0.1`, `[ssl] enable = false`, `enable_cors = false`, `[admins]` con contraseña **hasheada**, `authentication_handlers` con JWT (anexo C) | `ss -tlnp` muestra 5984 solo en `127.0.0.1` |
| P4 | nginx + certbot: configuración del anexo B (la validada en el anexo F), `certbot --nginx` o `certonly --webroot -w /var/www/letsencrypt`; eliminar el sitio `default` | `nginx -t`; `curl -I https://api.<dominio>`; `certbot renew --dry-run` |
| P5 | Llaves RSA (generadas en el propio servidor, privada `0640 root:buscobien-api`), usuario `buscobien-api`, servicio y mailer (anexo A) | `systemctl status`, login de prueba |
| P6 | Restaurar los datos: exportar desde desarrollo (`_all_docs?include_docs=true&attachments=true` o replicación) e importar por `127.0.0.1`; subir los *design documents* versionados en `db/design/` | Conteo de documentos por base igual al origen |
| P7 | `_security` y `validate_doc_update` por base (S4) con la matriz de pruebas | Matriz del plan en verde |
| P8 | Respaldos automáticos cifrados fuera del servidor, monitoreo externo, `fail2ban`, rotación de logs | Restauración de prueba en otro equipo |
| P9 | Compilar la app apuntando a `API_BASE_URL` de producción y probar de punta a punta (Web, Android, iOS, Windows) | Checklist de la sección 9 |

### 10.4 Lo que NO se debe llevar a producción

- Las llaves RSA, la contraseña de administrador ni los `.env` del ambiente de desarrollo ni de la instancia de pruebas: **se generan nuevas en el servidor de producción**.
- La interfaz `_utils` publicada ni los puertos 5984/6984/3001 abiertos.
- Los datos de prueba de `prueba_datos`/`prueba_usuarios`.

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

### B. nginx (`/etc/nginx/sites-available/buscobien.conf`) — versión validada en el anexo F

```nginx
# BuscoBien - nginx como unica entrada publica (candidato; ver plan_seguridad_nginx_jwt.md)
# Zonas de limite (http context: este archivo se incluye desde sites-enabled)
limit_req_zone $binary_remote_addr zone=auth_limit:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api_limit:10m  rate=20r/s;
limit_req_status 429;

map $http_origin $cors_origin {
    default                      "";
    "https://buscobien.net"      $http_origin;
    "https://www.buscobien.net"  $http_origin;
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
    ssl_session_cache shared:SSL:5m;
    ssl_session_timeout 1h;

    server_tokens off;

    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Access-Control-Allow-Origin $cors_origin always;
    add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
    add_header Access-Control-Max-Age 600 always;
    add_header Vary Origin always;

    if ($request_method = OPTIONS) { return 204; }

    # Autenticacion y usuarios (servicio buscobien-api)
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
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto https;
    }

    # Feed continuo del chat (sin buffering, conexion larga)
    location ~ ^/db/[^_/][^/]*/_changes$ {
        rewrite ^/db/(.*)$ /$1 break;
        proxy_pass http://127.0.0.1:5984;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_buffering off;
        proxy_read_timeout 75s;
    }

    # Rutas administrativas de CouchDB: nunca publicas
    location ~ ^/db/(_config|_node|_utils|_replicate|_users|_cluster_setup|_dbs_info|_all_dbs|_scheduler|_membership|_up|_active_tasks) {
        return 403;
    }

    # CouchDB con JWT nativo (la ruta original se conserva sin reescribir)
    location /db/ {
        limit_req zone=api_limit burst=60 nodelay;
        client_max_body_size 20m;
        # Conserva la codificacion original de la ruta (ids con %2F, _design/...)
        rewrite ^ $request_uri;
        rewrite ^/db/(.*) /$1 break;
        return 400;
        proxy_pass http://127.0.0.1:5984$uri;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto https;
        proxy_read_timeout 60s;
    }

    # Mailer (transitorio, solo mientras la app actual lo llame por aqui)
    location /api/mailer {
        proxy_pass http://127.0.0.1:3001/api;
    }

    location = / { return 404; }
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

Validado en la instancia de pruebas (anexo E): el *claim* de roles es `_couchdb.roles`, el `kid` es obligatorio y `required_claims = exp` funciona. **Pendiente de probar:** exigir también el emisor (`iss`) en `required_claims`.

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

### E. Resultados de la instancia de pruebas de JWT (2026-10-16)

**Qué se probó:** una segunda instancia de CouchDB 3.5.0 (mismo binario de `/opt/couchdb`) ejecutada como el usuario `deploy`, con nombre de nodo, cookie, datos y llaves propios, escuchando solo en `127.0.0.1:5985`. No usó ni modificó nada de la instancia de producción (su `uuid` es distinto y siguió respondiendo en 5984). Las llaves RSA y la contraseña de administrador de esa instancia son de usar y tirar y están en `~/couchdb-test/` (permisos `600`). La instancia **ya está detenida**; para volver a levantarla: `~/couchdb-test/start.sh`.

| # | Prueba | Resultado |
| :-- | :--- | :--- |
| 1 | Token RS256 con `kid`, `sub`, `exp` y `_couchdb.roles: ["usuario"]` | **Correcto:** `GET /_session` devuelve `name = sub`, `roles = ["usuario"]`, `authenticated = "jwt"` |
| 2 | Roles en un *claim* llamado `roles` (como en el plan original) | **Ignorado:** `roles = []`. Confirma que el plan original estaba mal; hay que usar `_couchdb.roles` |
| 3 | Token **sin `kid`** o con `kid` desconocido | **Rechazado con `400 Bad Request`** (`Unknown kid`); `_default` no se aplica. El `kid` es obligatorio |
| 4 | Firma con **otra llave** | **Rechazado con `400`** (`Bad signature`) |
| 5 | Token **expirado** | **`401`** (`exp not in future`) |
| 6 | Token **sin `exp`** (con `required_claims = exp`) | **Rechazado** (`400`) |
| 7 | `alg = none` y `alg = HS256` firmado con la llave pública como secreto (ataques clásicos) | **Rechazados** (`400`) |
| 8 | Permisos por base (`members.roles = ["usuario","promotor"]`) | Rol correcto → `200`; token sin rol → `403`; sin token → `401`; base solo-servicio → `403` |
| 9 | `_all_dbs` y `/_node/_local/_config` con token de usuario | `401` |
| 10 | `validate_doc_update` por propietario | El dueño crea y modifica (`201`); otro usuario modifica o crea a nombre ajeno → `403` |
| 11 | Convivencia: administrador con Basic | Sigue funcionando con el orden `cookie → jwt → default` (`200`); Basic incorrecto → `401` |
| 12 | `_changes?feed=continuous` con `Authorization: Bearer` | Funciona |
| 13 | CORS de CouchDB con `enable_cors = false` | Sin cabeceras CORS (correcto: lo hará nginx) |
| 14 | Token firmado con nuestra llave y `_couchdb.roles: ["_admin"]` | **CouchDB lo acepta como administrador** |

**Consecuencias para el diseño y el código:**

1. **`kid` obligatorio** y roles en `_couchdb.roles`: el anexo A ya lo hace así; ya no es una suposición sino un resultado verificado.
2. **El cliente debe tratar `400` y `401` como «sesión inválida».** Un token con firma o `kid` equivocados devuelve `400`, no `401`. En `ApiClient` (C0/C6): ante `401`, o `400` con `error: bad_request` y razón `Unknown kid`/`Bad signature`, intentar renovar una vez y si falla cerrar sesión.
3. **La llave privada equivale a la cuenta de administrador** (prueba 14): quien pueda firmar tokens puede emitir `_admin`. Hay que: (a) custodiar `private.pem` fuera de cualquier repositorio y con permisos `0640 root:buscobien-api`; (b) hacer que `buscobien-api` **nunca** copie roles que vengan del cliente y solo emita `usuario`/`promotor`; (c) añadir una prueba automática del servicio que verifique que un token emitido no contiene `_admin`; (d) rotar la llave si hay sospecha de filtración (esto invalida todas las sesiones).
4. **Mensajes de error:** las respuestas de rechazo no filtran información sensible (solo `Unknown kid`, `Bad signature`, `exp not in future`).
5. **Pendiente de probar** (requiere nginx, fase S2): comportamiento de `_changes` a través del proxy, `client_max_body_size` con fotos grandes, CORS desde `https://buscobien.net`, y el límite de peticiones.

### F. Instalación de nginx y certificado en el ambiente de desarrollo (2026-10-16)

**Qué se hizo en `190.92.151.34`** (Ubuntu 20.04, ambiente de desarrollo):

| Acción | Resultado |
| :--- | :--- |
| Instalar `nginx` 1.18.0 y `certbot` 0.40.0 con `apt` (con `policy-rc.d` para que nginx **no arrancara** y no chocara con Apache en el puerto 80) | Instalados; `nginx` **inactivo**, Apache sigue sirviendo el puerto 80 |
| Emitir el certificado de `api.buscobien.net` con `certbot certonly --webroot -w /var/www/html` (el reto HTTP-01 lo atendió Apache, sin interrupciones) | **Emitido** por Let's Encrypt, vence el **2027-01-14**; archivos en `/etc/letsencrypt/live/api.buscobien.net/`. Se registró **sin correo de contacto** (`--register-unsafely-without-email`) porque no se me indicó cuál usar; ver más abajo |
| Renovación automática | `certbot.timer` habilitado |
| Configuración candidata | Instalada en `/etc/nginx/sites-available/buscobien.conf` (**no habilitada**; ver anexo B). Sigue habilitado el sitio `default` de nginx, que se elimina al activar |

**Pendiente de este paso:**

1. **Correo de contacto del certificado:** `certbot update_account --email <correo>` para recibir avisos de vencimiento. Indica qué correo usar.
2. **Cambio del método de renovación al activar nginx:** mientras Apache atienda el puerto 80, la renovación usa `/var/www/html`; al sustituir Apache por nginx hay que cambiar `webroot_path` en `/etc/letsencrypt/renewal/api.buscobien.net.conf` a `/var/www/letsencrypt` y añadir un *hook* que recargue nginx tras renovar (`/etc/letsencrypt/renewal-hooks/deploy/`).
3. `certbot renew --dry-run`: `certbot renew --dry-run` terminó sin errores en el registro (staging de Let's Encrypt, reto HTTP-01 atendido por Apache); esta versión de certbot no imprime el aviso explícito de éxito en el resumen, por lo que conviene repetirlo con nginx activo.

**Pruebas del proxy** (nginx de prueba en `127.0.0.1:8444` con el **certificado real**, apuntando a la CouchDB de pruebas del anexo E; no se tocó Apache ni los puertos públicos; ambos procesos de prueba quedaron detenidos):

| # | Prueba | Resultado |
| :-- | :--- | :--- |
| 1 | `nginx -t` de la configuración candidata | Correcto |
| 2 | Certificado servido | `CN=api.buscobien.net`, emisor Let's Encrypt, vigente hasta 2027-01-14; HTTP/2 activo |
| 3 | TLS 1.1 | Rechazado |
| 4 | Cabeceras | `Strict-Transport-Security`, `X-Content-Type-Options`; `server_tokens off` |
| 5 | JWT a través del proxy | `/db/_session` con `Bearer` devuelve el usuario y los roles; sin token `401` |
| 6 | Rutas administrativas (`_utils`, `_config`, `_node`, `_all_dbs`, `_replicate`, `_users`, `_dbs_info`, `_up`) | Todas `403`; `/db/_users/_changes` también `403` (la excepción del feed no aplica a bases que empiezan por `_`) |
| 7 | Documento de 5 MB | Pasa (`201`) |
| 8 | Documento de 25 MB | `413` (límite de 20 MB) |
| 9 | Vista con `key=%22u1%22`, `_find` con cuerpo JSON | Correcto |
| 10 | **Id con `%2F`** | Con `proxy_pass …/` daba `404` (nginx decodifica la ruta). **Corregido** con `rewrite ^ $request_uri;` + `proxy_pass …$uri`; ahora `200`. Esta es la forma definitiva en el anexo B |
| 11 | Feed `_changes` continuo por el proxy | Primer byte en ≈ 11 ms, sin *buffering*; un documento escrito durante la captura **llegó al stream** |
| 12 | CORS | Origen `https://buscobien.net` permitido (`Access-Control-Allow-Origin`); origen ajeno: **sin** esa cabecera |
| 13 | Límite de peticiones | 120 peticiones seguidas: 119 `200` y 1 `429` (la zona de 20 peticiones/s y ráfaga de 60 actúa; el número exacto depende de la velocidad del cliente) |

Notas: tras corregir el punto 10 se repitieron las pruebas B–E con los datos de la corrida anterior, por lo que el PUT de 5 MB devolvió `409` (el documento ya existía) y el documento «en vivo» no generó un cambio nuevo; ambos casos se habían verificado en la primera corrida con la configuración anterior, que solo difería en la ruta de `/db/`.

**No probado todavía:** `/auth/*` y `/usuarios/*` (el servicio `buscobien-api` aún no existe), el proxy del mailer, la configuración con el puerto 443 real y el *dry-run* de renovación con nginx como servidor del puerto 80.

### G. Activación de nginx en el ambiente de desarrollo (2026-10-16)

| Paso | Resultado |
| :--- | :--- |
| Revisión previa de Apache | El registro de accesos solo muestra la página predeterminada de Ubuntu, escáneres, buscadores y los reintentos de Let's Encrypt; **0 peticiones a `/api/mailer`**. El propietario confirmó que no se usa |
| Correo de contacto del certificado | Actualizado a `admin@buscobien.com` (`certbot update_account`) |
| Renovación | `webroot_path` cambiado a `/var/www/letsencrypt` (copia de seguridad en `/root/api.buscobien.net.conf.bak`) y gancho `deploy` que recarga nginx |
| Sustitución | `apache2` detenido y **deshabilitado**; sitio `default` de nginx retirado; `buscobien.conf` habilitado; `nginx -t` correcto; `nginx` activo y habilitado en 80 y 443 |
| Verificación | `http://api.buscobien.net` → `301` a HTTPS; `https://api.buscobien.net/db/` → CouchDB de producción vía nginx (`200`, HSTS); `/` → `404`; `/db/_utils/` → `403`; `/auth/login` → `502` (el servicio aún no existe); el reto de renovación lo sirve nginx |
| `certbot renew --dry-run` con nginx | **Correcto** al segundo intento (el primero falló con `authorization must be pending`, una condición transitoria del entorno de pruebas de Let's Encrypt al repetir la prueba en pocos minutos) |
| Efecto lateral | `https://api.buscobien.net/db/` ya es una **segunda puerta pública** a la CouchDB de producción (con TLS válido, límite de peticiones y rutas administrativas bloqueadas, pero todavía aceptando la contraseña de administrador por Basic). Hasta el corte S5 el riesgo equivale al del puerto 6984 existente |
| No hecho | Los puertos 5984, 6984 y 3001 siguen abiertos (la app actual los usa) |

### H. Comandos del propietario y estado de `buscobien-api` (2026-10-17)

**Servicio `buscobien-api` (pasos 2–4 del plan, repositorio `D:\buscobien-api`, commit `5a69ad2`):** escrito y probado en local con 50 pruebas automáticas (repositorios en memoria y `fetch` simulado; sin CouchDB ni red) y `npm audit` sin vulnerabilidades. **Aún no está desplegado.** Decisiones aplicadas: tokens de 15 min / 30 días, contraseña de 8 o más caracteres con letras y números, campos públicos de búsqueda `id`, `nombre`, `foto` y `perfil`, nombre de usuario como identificador de acceso.

Desviaciones y detalles que conviene conocer:

- **Acceso a CouchDB con `fetch`, no con `nano`** (convención del `CLAUDE.md`): `nano` 10 está en desuso y exige sesión por cookies; `fetch` permite probar sin red y quita una dependencia.
- **Hash de contraseña:** bcrypt en `usuario.claveacceso_v2`. El SHA-256 heredado (`usuario.claveacceso`) se acepta una vez, se migra y **se conserva mientras `KEEP_LEGACY_HASH=true`** para que la app actual (que lo lee directo de CouchDB) siga funcionando; se elimina en el corte S5.
- **Supuesto a confirmar con datos reales:** el `_id` del documento de usuario coincide con `usuario.id_usuario` (los usuarios nuevos se crean así).
- **El cliente debe serializar las renovaciones** de token: dos renovaciones simultáneas con el mismo token se interpretan como reutilización y cierran la sesión.
- Los usuarios existentes sin `usuario.correoelectronico` único o repetido pueden dar resultados ambiguos en la recuperación; conviene revisar duplicados.

**Paso A — lo ejecuta el propietario (`deploy`, con `sudo`).** El script `~/seguridad/paso_A.sh` ya está en el servidor, con la sintaxis verificada:

```powershell
ssh miservidor
```

```bash
bash ~/seguridad/paso_A.sh
```

Pide la contraseña de `sudo` y la contraseña **actual** del administrador de CouchDB, y hace, en orden:

| # | Acción | Si falla |
| :-- | :--- | :--- |
| 0 | Comprueba que CouchDB responde, que existen las llaves en `/etc/buscobien-api/` y que la contraseña actual es correcta | Se detiene sin cambiar nada |
| 1 | Respalda el `_security` actual de las bases de usuarios en `~/seguridad/respaldo/` | — |
| 2 | **Rota la contraseña de administrador** (aleatoria, 32 caracteres), la muestra una vez y la guarda en `~/seguridad/admin.nueva` | Se detiene; la anterior sigue vigente |
| 3 | Elimina la contraseña en texto plano de `local.ini` (solo si el hash nuevo quedó en `local.d/10-admins.ini`) y deja ambos archivos en `0640` | Avisa y no toca `local.ini` |
| 4 | Crea la cuenta de servicio `buscobien_api` (no administradora) y guarda su contraseña en `/etc/buscobien-api/couchdb_service.pass` (`0640 root:buscobien-api`), sin mostrarla | Se detiene |
| 5 | Crea `buscobien_sesiones`, deja `buscobien_api` como único miembro de las bases de usuarios y de sesiones, y crea los índices | Informa el código HTTP de cada base |
| 6 | Instala `20-jwt.ini`, reinicia CouchDB y comprueba que el administrador sigue entrando y que aparece el manejador `jwt` | Indica el comando de diagnóstico |

Después del script:

1. Guardar la contraseña nueva en el gestor de contraseñas y ejecutar `rm ~/seguridad/admin.nueva`.
2. Poner la contraseña nueva en `defines.json` (`COUCHDB_PASSWORD`) y recompilar la app de desarrollo.
3. Avisar para el despliegue del servicio.

**Efectos esperados:** la app de desarrollo seguirá funcionando (el administrador por Basic sigue aceptado) una vez que `defines.json` tenga la contraseña nueva; durante unos segundos CouchDB no responderá por el reinicio. Las bases de usuarios dejan de ser accesibles para cualquier usuario que no sea el administrador o `buscobien_api`.

**Paso B — lo ejecuta Claude con `miservidor-root`, después del paso A:** copiar el servicio a `/opt/buscobien-api`, `npm ci --omit=dev`, crear el `.env` (`0600`, sin contraseñas: usa los archivos de `/etc/buscobien-api/`), instalar `deploy/buscobien-api.service`, arrancar el servicio, correr las pruebas contra la CouchDB de desarrollo y verificar `https://api.buscobien.net/auth/login`.

### I. Ejecución del paso A y despliegue de `buscobien-api` en desarrollo (2026-10-17)

| Paso | Resultado |
| :--- | :--- |
| Paso A (propietario, `paso_A.sh`) | Completado sin errores: respaldos de `_security` en `~/seguridad/respaldo/`; contraseña de administrador rotada; texto plano eliminado de `local.ini` (0 entradas); cuenta `buscobien_api` creada; base `buscobien_sesiones` creada; `_security` fijado en esa base y en las tres bases de usuarios; índices creados; JWT activo (`"authentication_handlers":["cookie","jwt","default"]`); el administrador sigue entrando tras el reinicio |
| Respaldo cifrado de la llave privada | Hecho por el propietario; copia local verificada (2480 bytes, formato `Salted__`); la copia del servidor se eliminó |
| Despliegue (Claude, paso B) | `/opt/buscobien-api` (código `root:root`, `.env` `0640 root:buscobien-api` **sin contraseñas**), `npm ci --omit=dev`, unidad `systemd` habilitada, escucha solo en `127.0.0.1:3000`, ≈ 64 MB de memoria |
| Pruebas con el Node del servidor (18.20) | 50 de 50 |
| Prueba de humo (`scripts/smoke.mjs`, 18 comprobaciones) | **Todo correcto**, incluida la validación del JWT por la CouchDB real a través de nginx, el cierre de las bases de usuarios para un token de usuario (403), la reutilización de un token de renovación (cierra la familia) y el borrado del usuario de prueba y sus 5 sesiones |
| Visibilidad pública | `https://api.buscobien.net/auth/login` y `/usuarios/me` responden desde nginx; `/health` **no** está publicado (404) |

**Hallazgo con datos reales:** en `buscobien_usuarios` (1 documento) y `buscobien_usuarios_promotores` (3) el `_id` de CouchDB (32 hex) **no** coincide con `usuario.id_usuario` (64 hex). El servicio ya lo contempla (`sub = id_usuario`, claim `did = _id`) y los usuarios nuevos usan el mismo formato que los existentes.

**Seguridad pendiente tras estos pasos:**

1. La nueva contraseña de administrador **apareció en la conversación de trabajo**; rotarla otra vez antes de pasar a producción (la producción nueva genera la suya).
2. `https://api.buscobien.net/db/` sigue aceptando la contraseña de administrador por Basic hasta el corte S5.
3. La vista `vistaNOMBRE` de `DDUSER` emite el documento completo (incluido el hash). Mientras la app antigua la use, cualquier cuenta con acceso de lectura a la base ve los hashes; se retira en S5 con el cambio C5 del código de la app.
4. El mailer sigue sin poder enviar correos (H8): la recuperación de contraseña de punta a punta no se ha podido probar.

**Siguientes pasos:** S4 (permisos por base y `validate_doc_update` en las demás bases, con inventario del campo de propietario de cada una), cambios C0–C7 en la app Flutter, arreglar el SMTP del mailer y publicar los dos commits nuevos de `buscobien-api` (`2ae1014` y el de los identificadores).

### J. Decisiones D7–D10 y preparación de S4 (2026-10-17)

**Decisiones del propietario:**

| ID | Decisión | Aplicación |
| :--- | :--- | :--- |
| D7 | **Opción C** | Catálogo y datos del propietario se abren con regla de escritura por propietario; quedan **cerradas** (solo administrador / `buscobien-api`) `buscobien_mensajes`, `buscobien_grupos_mensajes`, `buscobien_user_localidad`, `buscobien_compra_espacios`, `buscobien_listas_prop_compartidas`, `buscobien_grupos_publicaciones` y `buscobien_social`, hasta que existan sus endpoints en `buscobien-api` |
| D8 | El catálogo se ve **sin iniciar sesión** (usuarios sin cuenta o sin sesión). Listas, grupos, contactos y demás funciones exigen sesión | `publicados_*`, `propiedades_casas_fotos`, `fotos_ordenadas` y las dos bases de referencia quedan con lectura anónima; escribir sin sesión devuelve `401` |
| D9 | Corregir el código para usar `publicados_*` / `casas_comprados_*` | Hecho (commit `7684004` del repositorio `buscobien`): burbujas de propiedad del chat y del detalle de grupo, perfil de contacto y compartir con un conocido; se eliminó código sin uso que consultaba bases inexistentes |
| D10 | Respaldar y cerrar `buscobien_social`; borrarla cuando se confirme que nada la usa | Se retiró del cliente el código que la usaba (`InvitacionesNotifier`, `chatProvider`); la base queda cerrada con el paso S4 y su `_security` anterior se guarda en el respaldo. **El borrado se hará tras confirmar que no hay otros consumidores** |
| — | La CouchDB de desarrollo la comparten varios proyectos; **en producción solo existirán las bases de BuscoBien** | Las 22 bases de otros proyectos no entran en S4. La producción nueva se crea solo con las 34 bases de BuscoBien |

**Cambios en la app (`buscobien`, commit `7684004`):** nuevo `lib/08_pantallas/propiedades/buscar_propiedad.dart` (`buscarPropiedadPublicada`, `propiedadesPublicadasDeUsuario`); compartir con un conocido ya no escribe en la base inexistente (antes mostraba «No se pudo compartir» aunque el mensaje sí se enviaba); eliminados `provider_propiedades_compartidas_conocidos.dart`, `propertiesDetailsProvider`, `getPropiedadesDetallesPorListaId` y ≈ 150 líneas del motor social antiguo. `flutter analyze` 0 hallazgos; 75 pruebas verdes. No se probó en un dispositivo: conviene probar a mano las burbujas de propiedad en el chat y el perfil de un contacto.

**Reglas de S4 (repositorio `buscobien-api`, `scripts/s4/`):** `reglas.mjs` (30 bases: reglas `validate_doc_update` y tipo de acceso), `aplicar.mjs` (simular / aplicar / revertir, con respaldo del `_security` y del diseño de cada base; instala primero la regla y después abre el acceso), `verificar.mjs` (matriz de pruebas con dos usuarios) y `paso_s4.sh` (flujo completo para el servidor). Reglas implementadas: solo administrador; propietario; invitaciones (crea el remitente, responde el destinatario); lista compartida; grupos (el administrador edita; los demás solo se añaden o salen ellos mismos).

**Prueba en la instancia de pruebas (30 bases con los nombres reales):** simular → aplicar → **208 de 208 comprobaciones correctas** → revertir (la base vuelve a «solo administrador»). La matriz comprueba, por base: lectura con y sin sesión según el acceso; que un usuario no pueda modificar, borrar ni crear a nombre de otro; que el propietario no se pueda reasignar; que el destinatario responda la invitación y el remitente no; y que un miembro de un grupo no pueda hacerse administrador, editar el grupo, expulsar ni borrarlo.

**Limitaciones conocidas de las reglas (documentadas):**

1. En `buscobien_grupos` cualquier usuario con sesión puede añadirse a un grupo (incluso privado): CouchDB no puede comprobar la invitación, que está en otra base.
2. En `buscobien_grupos_avisos` basta ser el autor; no se comprueba que sea administrador del grupo.
3. Con la opción C, las bases abiertas a usuarios con sesión (listas, «me gusta», invitaciones, `casas_comprados_*`, avatares, listas compartidas, grupos) pueden **leerse** por cualquier usuario con sesión con una consulta propia.

**Pendiente de aplicar en el servidor (lo ejecuta el propietario):**

```powershell
ssh miservidor
```
```bash
bash /opt/buscobien-api/scripts/s4/paso_s4.sh
```

El script pide la contraseña de `sudo` y la del administrador; muestra la simulación y exige escribir `SI` para continuar; guarda el respaldo en `~/seguridad/respaldo_s4/`; aplica; crea dos usuarios temporales, ejecuta la matriz de pruebas contra la CouchDB real y comprueba por HTTPS el catálogo sin sesión; borra los usuarios temporales; y termina con `RESULTADO: TODO CORRECTO` o la lista de fallos. Para deshacerlo: `bash /opt/buscobien-api/scripts/s4/paso_s4.sh revertir`.

**Efecto sobre la app actual:** ninguno mientras use el administrador (el administrador pasa todas las reglas). Las reglas solo afectan a los clientes que usen JWT.

### K. S4 aplicado en el ambiente de desarrollo (2026-10-17)

El propietario ejecutó `paso_s4.sh` en el servidor:

| Paso | Resultado |
| :--- | :--- |
| Simulación | 30 bases listadas sin errores |
| Aplicación | 30 bases **aplicadas** sin errores; respaldo del `_security` anterior de cada base en `~/seguridad/respaldo_s4/` (reversión con `paso_s4.sh revertir`) |
| Matriz de pruebas con dos usuarios temporales, contra la CouchDB real | **208 de 208 comprobaciones correctas** (las mismas que en la instancia de pruebas) |
| Comprobaciones por HTTPS | Catálogo sin sesión `200`; códigos postales sin sesión `200`; mensajes privados con sesión `403` |
| Limpieza | 2 usuarios temporales borrados (con sus sesiones) |

Estado resultante: catálogo y referencia legibles sin sesión; las bases del propietario y de la red social (sin chat) abiertas a usuarios con sesión y con escritura limitada al propietario; mensajes, domicilio, compras, listas compartidas por propiedad, publicaciones de grupo y `buscobien_social` **cerradas**. La app actual (que usa la contraseña de administrador) no se ve afectada.

**CI (GitHub Actions):** la primera ejecución falló porque el código usaba `ScrollCacheExtent`, que no existe en Flutter *stable* (solo en *master*); se corrigió con `cacheExtent` (commit `2fb43d9`). La app ya es compilable con *stable*.

**Siguiente:** endpoints de `buscobien-api` para las bases cerradas (compras → H-37, domicilio, mensajes privados y de grupo con canal en vivo, listas compartidas por propiedad), y cambios C0–C7 en la app.
