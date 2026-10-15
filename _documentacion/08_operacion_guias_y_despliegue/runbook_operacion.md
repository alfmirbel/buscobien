# Runbook de operación — BuscoBien

**Creado:** 2026-10-07.  
**Alcance:** verificaciones, respaldo y restauración de CouchDB, despliegue de la app Web y del mailer, respuesta a incidentes y rotación de credenciales.  
**Estado de verificación:** los comandos de CouchDB son la API estándar y los del mailer/Flutter salen del repositorio; **ninguno se ha ejecutado contra el servidor desde esta documentación**. Validar cada procedimiento en un entorno de prueba antes de depender de él. La conexión SSH y los alias están en [`ssh_servidor_y_despliegue.md`](ssh_servidor_y_despliegue.md).

> **Reglas del proyecto:** antes de modificar CouchDB en producción, hacer respaldo; para cambios grandes en el servidor, mostrar el plan y esperar confirmación; nunca escribir contraseñas en documentos ni en comandos guardados (usar variables de entorno).

## 1. Verificación diaria rápida (PowerShell)

```powershell
ssh miservidor "echo ok"                                   # acceso SSH
ssh miservidor "curl -s https://citigov.cloud:6984/"        # CouchDB responde con {"couchdb":"Welcome",...}
ssh miservidor "pm2 status"                                 # buscobien-mailer en línea
ssh miservidor "df -h / ; free -h"                          # disco (20 GB) y memoria (1 GB)
```

Umbrales sugeridos: disco > 80 % o memoria libre < 150 MB → revisar (el servidor tiene 1 GB de RAM).

## 2. Respaldo de CouchDB

**Frecuencia recomendada:** diaria para bases de datos de negocio; antes de cualquier cambio masivo. Retención sugerida: 7 diarias + 4 semanales. *(Hoy no hay evidencia de un respaldo automático; confirmar en el servidor.)*

### 2.1 Lista de bases a respaldar
Todas las de [`bases_de_datos_en_codigo.md`](../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md) más las del diccionario que existan en el servidor (`GET /_all_dbs`).

### 2.2 Respaldo por replicación a un archivo/otra instancia (ejemplo por base)
```bash
# En el servidor, con la contraseña en una variable de entorno (no en el comando)
export COUCHDB_PASSWORD='...'            # definir fuera del historial
DB=buscobien_usuarios
curl -s -u admin:$COUCHDB_PASSWORD "https://citigov.cloud:6984/$DB/_all_docs?include_docs=true&attachments=true" \
  -o "backup_${DB}_$(date +%F).json"
```
Para bases con adjuntos grandes (fotos, avatares) es preferible copiar el directorio de datos de CouchDB con el servicio detenido, o replicar a otra instancia con `POST /_replicate`.

### 2.3 Restauración
```bash
# Crear la base si no existe y cargar los documentos
curl -s -X PUT  -u admin:$COUCHDB_PASSWORD "https://citigov.cloud:6984/$DB"
curl -s -X POST -u admin:$COUCHDB_PASSWORD -H "Content-Type: application/json" \
  "https://citigov.cloud:6984/$DB/_bulk_docs" -d @bulk.json   # {"docs":[...]} sin _rev
```
Después restaurar los *design documents* (`_design/...`): hoy no están versionados en el repositorio salvo `server/setup_couchdb_propietarios.sh`; **conviene guardarlos en `db/design/`**.

### 2.4 Prueba de restauración
Trimestral: restaurar un respaldo en una instancia de prueba y comprobar conteo de documentos y una vista (`vistaUserID`).

## 3. Despliegue de la app Web (WASM)

```powershell
flutter build web --wasm --dart-define-from-file=defines.json
```
- `defines.json` **no se versiona** y contiene las credenciales que se compilan en el bundle (ver [`modelo_de_amenazas.md`](../04_arquitectura_y_diseno/modelo_de_amenazas.md) T1).
- Publicar el contenido de `build/web/` en el servidor web (Apache). Verificar tras el despliegue: carga de la página, login, mapa y que `/recuperar` cargue la app.

### Checklist previo a producción
- [ ] `flutter analyze` sin errores y `flutter test` pasa.
- [ ] Compilado con `--wasm` y con las claves de Google correctas.
- [ ] Respaldo de CouchDB reciente.
- [ ] `defines.json` no está en el commit.
- [ ] Verificación de documentación: `python _documentacion/00_indice/verificar_documentacion.py` sin errores.

## 4. Despliegue del mailer (`buscobien-mailer`)

```bash
scp -P 7822 -r server/buscobien-mailer deploy@190.92.151.34:~/buscobien-mailer
ssh miservidor
cd ~/buscobien-mailer && npm install
cp .env.example .env && nano .env        # SMTP_*, DEEP_LINK_BASE, PORT
pm2 start server.js --name buscobien-mailer && pm2 save
```
Apache: `ProxyPass /api/mailer http://localhost:3001/api` (módulos `proxy`, `proxy_http`). Prueba:
```bash
curl -X POST http://localhost:3001/api/enviar-correo-recuperacion -H "Content-Type: application/json" \
  -d '{"email":"prueba@ejemplo.com","nombreUsuario":"Prueba","resetToken":"abc123","perfil":"Usuario"}'
```
Respuesta esperada: `{"success":true,"message":"Correo enviado"}`. Hoy la app llama a `http://citigov.cloud:3001/...` directamente; pasar a HTTPS por el proxy está pendiente (T7).

## 5. Enlace de recuperación de contraseña (solo Web)

**Decisión (2026-10-15):** el alcance es la aplicación Web. No se publican `assetlinks.json` ni `apple-app-site-association`, y no hacen falta `applicationId`, huella SHA-256 ni `TEAM_ID`. La configuración de App Links/Universal Links que existe en `AndroidManifest.xml` y `Runner.entitlements` queda sin uso.

**Cómo funciona:** el correo trae `DEEP_LINK_BASE?token=…&perfil=…` (`https://buscobien.net/recuperar`). Al cargar la app Web, `deep_link_handler.dart` lee `Uri.base`, y si la ruta contiene `/recuperar` con `token` y `perfil` abre la pantalla de cambio de contraseña.

**Verificación en el servidor Web:**
1. Apache debe devolver `index.html` para cualquier ruta que no sea un archivo (reescritura de SPA), de modo que `/recuperar` no responda 404.
2. `DEEP_LINK_BASE` del mailer debe apuntar al host que sirve la app.
3. Prueba de extremo a extremo: solicitar recuperación → abrir el enlace del correo en el navegador → cambiar la contraseña.

**Hallazgo (2026-10-15):** `https://buscobien.net` se sirve desde **GitHub Pages**, no desde este servidor, y `https://buscobien.net/recuperar?...` responde **404** porque falta el *fallback* de SPA. Al publicar la web hay que copiar `index.html` a `404.html`. Los puntos 1 y 2 de arriba (Apache) solo aplican si la web se muda al servidor; ver [`plan_seguridad_nginx_jwt.md`](plan_seguridad_nginx_jwt.md) (D2).

## 6. Respuesta a incidentes

| Incidente | Primeras acciones |
| :--- | :--- |
| Sospecha de filtración de credenciales de CouchDB | 1) Respaldar. 2) Cambiar la contraseña de administrador en CouchDB. 3) Recompilar y publicar la app con el nuevo `defines.json` (las versiones antiguas dejarán de funcionar). 4) Revisar accesos y documentos modificados. |
| Correos de recuperación no llegan | `pm2 logs buscobien-mailer`; validar `SMTP_*`; probar el `curl` de la sección 4. |
| CouchDB no responde | `sudo systemctl status couchdb`; `sudo journalctl -u couchdb --no-pager -n 50`; revisar disco y memoria. |
| Disco lleno | Identificar bases grandes (fotos, avatares), compactar (`POST /{db}/_compact`) y ampliar/limpiar tras respaldar. |
| Enlace de recuperación abre el navegador y no la app | Revisar sección 5 (reescritura a `index.html` y `DEEP_LINK_BASE`). |

Registrar cada incidente (fecha, causa, acción, prevención) en un archivo de bitácora del proyecto.

## 7. Rotación de credenciales

Mientras las credenciales de CouchDB estén compiladas en la app (estado actual), **rotarlas obliga a publicar una nueva versión** de todas las plataformas. Esta limitación desaparece al migrar a API + JWT (credenciales solo en el servidor).
