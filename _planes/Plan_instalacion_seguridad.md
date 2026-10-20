[14/09/2026 04:12 p. m.] AsistenteAM en respuesta a Alfonso Mireles:

> ‎⁨Estas generando el plan?⁩
> Plan de Implementación de Seguridad JWT + Nginx para Buscobien
> Servidor de destino: Ubuntu (VPN: 100.67.186.46)  
> Fecha de planificación: 14 de septiembre de 2026  
> Estado: PLAN NO EJECUTADO (solo documentación)

---

📋 RESUMEN EJECUTIVO

Este plan integra dos capas críticas de seguridad para Buscobien:

1. Nginx como proxy inverso y terminador SSL - Única puerta de entrada pública
2. Autenticación JWT con llaves RSA (RS256) - Desacoplada de CouchDB

Arquitectura resultante:

```
Internet
    ↓ (HTTPS 443)
Nginx (SSL + Proxy)
    ↓ (localhost / VPN)
    ├→ Flutter Web (Wasm) → Archivos estáticos
    ├→ Node.js Auth (3000) → Emisión de JWT con RSA-2048
    └→ CouchDB (5984) → Validación nativa de JWT con llave pública
```

---

🎯 OBJETIVOS

Proxy inverso unificado
• Descripción: Nginx como única entrada pública
• Métrica de éxito: Nginx escucha en 443, servicios internos solo en localhost

SSL/TLS terminado en Nginx
• Descripción: Todo tráfico público encriptado
• Métrica de éxito: Certificado Let's Encrypt válido en api.buscobien.com

Autenticación JWT RS256
• Descripción: Tokens firmados con RSA-2048, validados por CouchDB
• Métrica de éxito: Login devuelve JWT válido, CouchDB acepta tokens con `Authorization:

Seguridad de CouchDB
• Descripción: No expuesto directamente a internet
• Métrica de éxito: CouchDB bind en 127.0.0.1, acceso solo vía Nginx

Rate limiting
• Descripción: Protección contra abuso en endpoints de API
• Métrica de éxito: `limit_req` configurado en Nginx

---

## 📁 ESTRUCTURA DE DIRECTORIOS Y ARCHIVOS

`/etc/nginx/sites-available/buscobien.conf`
• Propósito: Configuración de Nginx
• Permisos: `root:root 644`

`/etc/nginx/sites-enabled/buscobien.conf`
• Propósito: Symlink activo
• Permisos: `root:root 777` (symlink)

`/etc/letsencrypt/live/buscobien.net/`
• Propósito: Certificados SSL (Certbot)
• Permisos: `root:root 755`

`/opt/auth-service/`
• Propósito: Microservicio de autenticación Node.js
• Permisos: `auth-user:auth-user 755`

`/opt/auth-service/server.js`
• Propósito: Código del servicio de auth
• Permisos: `auth-user:auth-user 644`

`/opt/auth-service/private.pem`
• Propósito: Llave privada RSA-2048 (SOLO LECTURA)
• Permisos: `auth-user:auth-user 400`

`/opt/auth-service/public.pem`
• Propósito: Llave pública RSA-2048
• Permisos: `auth-user:auth-user 644`

`/opt/couchdb/etc/local.ini`
• Propósito: Configuración de JWT en CouchDB
• Permisos: `couchdb:couchdb 600`

`/var/www/buscobien_web/`
• Propósito: Archivos estáticos Flutter Web (Wasm)
• Permisos: `www-data:www-data 755`

---

## 📅 FASES DE IMPLEMENTACIÓN

### FASE 0: PRERREQUISITOS Y PREPARACIÓN

Duración estimada: 15 minutos

Conectar al servidor
• Comandos: `ssh usuario@100.67.186.46`
• Verificación: Login exitoso

Verificar versión de Ubuntu
• Comandos: `lsb_release -a`
• Verificación: Ubuntu 22.04+ preferido

Actualizar repositorios
• Comandos: `sudo apt update && sudo apt upgrade -y`
• Verificación: Sin errores

Verificar espacio en disco
• Comandos: `df -h`
• Verificación: ≥ 2GB disponibles

---

### FASE 1: INSTALACIÓN DE NGINX Y CERTBOT

Duración estimada: 10 minutos

#### 1.1 Instalar Nginx

```bash
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

Verificación:

```bash
sudo systemctl status nginx
curl -I http://localhost
```

#### 1.2 Configurar Firewall (UFW)

```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
```

Verificación:

```bash
sudo ufw status
```

#### 1.3 Instalar Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

#### 1.4 Preparar DNS

REQUISITO PREVIO: Los registros DNS deben apuntar a 100.67.186.46:

- `buscobien.net` → A 100.67.186.46
- `api.buscobien.com` → A 100.67.186.46
- `n8n.buscobien.com` → A 100.67.186.46

Verificación DNS:\*

```bash
dig +short buscobien.net
dig +short api.buscobien.com
```

(1/5)
[14/09/2026 04:12 p. m.] AsistenteAM: ```bash

````

---

### FASE 2: GENERACIÓN DE LLAVES RSA
Duración estimada: 5 minutos

#### 2.1 Crear directorio para llaves
```bash
sudo mkdir -p /opt/auth-service
sudo chown $USER:$USER /opt/auth-service
cd /opt/auth-service
````

#### 2.2 Generar llave privada (2048 bits)

```bash
openssl genrsa -out private.pem 2048
```

#### 2.3 Extraer llave pública

```bash
openssl rsa -in private.pem -pubout -out public.pem
```

#### 2.4 Verificar llaves

```bash
# Verificar llave privada
openssl rsa -in private.pem -check

# Verificar llave pública
openssl rsa -pubin -in public.pem -text -noout
```

#### 2.5 Establecer permisos (CRÍTICO)

```bash
chmod 400 private.pem  # Solo lectura para propietario
chmod 644 public.pem   # Legible para configuración
```

---

### FASE 3: CONFIGURACIÓN DE COUCHDB CON JWT

Duración estimada: 10 minutos

#### 3.1 Verificar instalación de CouchDB

```bash
curl -I http://127.0.0.1:5984
```

#### 3.2 Editar configuración local

```bash
sudo nano /opt/couchdb/etc/local.ini
```

Agregar/modificar las siguientes secciones:

```ini
[chttpd]
# Habilitar JWT y cookie auth
authentication_handlers = {chttpd_auth, jwt_auth}, {chttpd_auth, cookie_auth}
bind_address = 127.0.0.1  # Solo accesible localmente

[jwt_auth]
required_claims = exp

[jwt_keys]
# Pegar contenido de /opt/auth-service/public.pem
rsa:buscobien = -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...
[... contenido completo de public.pem ...]
-----END PUBLIC KEY-----

[cors]
credentials = true
origins =
```

#### 3.3 Reiniciar CouchDB

```bash
sudo systemctl restart couchdb
```

#### 3.4 Verificar configuración

```bash
curl http://127.0.0.1:5984/_up
```

---

### FASE 4: MICROSERVICIO DE AUTENTICACIÓN (NODE.JS)

Duración estimada: 20 minutos

#### 4.1 Crear directorio del servicio

```bash
cd /opt/auth-service
sudo npm init -y
```

#### 4.2 Instalar dependencias

```bash
sudo npm install express jsonwebtoken axios cors dotenv
```

#### 4.3 Crear archivo `.env`

```bash
nano .env
```

Contenido:

```env
PORT=3000
COUCHDB_URL=http://127.0.0.1:5984
JWT_EXPIRY=24h
NODE_ENV=production
```

#### 4.4 Crear `server.js`

Archivo completo según documento:

```javascript
const express = require('express');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());

// Permitir peticiones desde la web
app.use(cors({ origin: 'https://www.buscobien.net' }));

// Cargar la Llave Privada
const PRIVATE_KEY=fs.rea...em', 'utf8');
const COUCHDB_URL = process.env.COUCHDB_URL  "http://127.0.0.1:5984";

app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        // 1. Verificar credenciales reales contra CouchDB
        const authCheck = await axios.post(`${COUCHDB_URL}/_session`, {
            name: username,
            password: password
        });

        // 2. Extraer roles del usuario
        const userRoles = authCheck.data.roles  [];

        // 3. Construir Payload (Claims)
        const payload = {
            sub: username,      // Obligatorio: Usuario de CouchDB
            roles: userRoles,   // Obligatorio: Roles para validación
            exp: Math.floor(Date.now() / 1000) + (60  60 * 24) // 24 Horas
        };

        // 4. Firmar Token (RS256)
        const token = jwt.sign(payload, PRIVATE_KEY, { algorithm: 'RS256' });

        res.json({ token });

    } catch (error) {
        console.error("Login fallido:", error.message);
        res.status(401).json({ error: "Credenciales inválidas" });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Auth Service puerto ${PORT}`));
```

#### 4.5 Configurar permisos

```bash
chmod 644 server.js .env
```

#### 4.6 Crear usuario del servicio

```bash
sudo useradd -r -s /bin/false auth-service
sudo chown -R auth-service:auth-service /opt/auth-service
```

#### 4.7 Crear servicio systemd

```bash

```

(2/5)
[14/09/2026 04:12 p. m.] AsistenteAM: ```bash
sudo nano /etc/systemd/system/auth-service.service

````

Contenido:
```ini
[Unit]
Description=Buscobien Auth Service (JWT)
After=network.target couchdb.service

[Service]
Type=simple
User=auth-service
WorkingDirectory=/opt/auth-service
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
````

#### 4.8 Activar servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable auth-service
sudo systemctl start auth-service
```

#### 4.9 Verificar servicio

```bash
sudo systemctl status auth-service
curl -X POST http://127.0.0.1:3000/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password": ""}'
```

---

### FASE 5: CONFIGURACIÓN DE NGINX COMO PROXY INVERSO

Duración estimada: 15 minutos

#### 5.1 Crear configuración de Nginx

```bash
sudo nano /etc/nginx/sites-available/buscobien.conf
```

Contenido completo:

```nginx
# Definir zona de rate limiting
limit_req_zone $binary_remote_addr zone=buscobien_limit:10m rate=10r/s;

# Grupo upstream para balanceo futuro (opcional)
upstream buscobien_api_backend {
    server 127.0.0.1:3000;
    # En fase 2/3, agregar más servidores aquí:
    # server 100.67.186.47:3000;
    # server 100.67.186.48:3000;
}

# Server para HTTP (redirigir a HTTPS)
server {
    listen 80;
    server_name buscobien.net api.buscobien.com n8n.buscobien.com;

    # Redirigir todo a HTTPS
    return 301 https://$server_name$request_uri;
}

# Server principal HTTPS
server {
    listen 443 ssl http2;
    server_name buscobien.net api.buscobien.com n8n.buscobien.com;

    # Configuración SSL (Certbot añadirá esto automáticamente)
    # ssl_certificate /etc/letsencrypt/live/buscobien.net/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/buscobien.net/privkey.pem;

    # Configuración SSL segura
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;

    # Headers de seguridad
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Archivos estáticos Flutter Web (Wasm)
    location / {
        root /var/www/buscobien_web;
        try_files $uri $uri/ /index.html;

        # Headers para Wasm (Cross-Origin Isolation)
        add_header Cross-Origin-Opener-Policy "same-origin" always;
        add_header Cross-Origin-Embedder-Policy "credentialless" always;
    }

    # API de Login → Node.js Auth Service
    location /api/login {
        proxy_pass http://127.0.0.1:3000/login;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API general → CouchDB (con JWT auth)
    location /api/ {
        # Remover prefijo /api/ antes de pasar a CouchDB
        rewrite ^/api/(.) /$1 break;
        proxy_pass http://127.0.0.1:5984;

        # Rate limiting
        limit_req zone=buscoboen_limit burst=20 nodelay;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Authorization $http_authorization;
    }

    # n8n (opcional, vía subdominio o path)
    location /n8n/ {
        rewrite ^/n8n/(.*) /$1 break;
        proxy_pass http://127.0.0.1:5678;
        proxy_http_version 1.1;

        # Headers para WebSockets/SSE
        proxy_set_header Connection '';
        chunked_transfer_encoding off;
        proxy_buffering off;
        proxy_cache off;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
```

(3/5)
[14/09/2026 04:12 p. m.] AsistenteAM: ```nginx
}

    # Qdrant (SOLO acceso VPN/Tailscale)
    location /qdrant/ {
        # Permitir solo localhost y red VPN
        allow 127.0.0.1;
        allow 100.67.186.0/24;  # Ajustar según tu red VPN
        deny all;

        rewrite ^/qdrant/(.) /$1 break;
        proxy_pass http://127.0.0.1:6333;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

}

````

#### 5.2 Crear enlace simbólico
```bash
sudo ln -s /etc/nginx/sites-available/buscobien.conf /etc/nginx/sites-enabled/
````

#### 5.3 Verificar sintaxis

```bash
sudo nginx -t
```

#### 5.4 Desactivar configuración default

```bash
sudo rm /etc/nginx/sites-enabled/default
```

#### 5.5 Reiniciar Nginx

```bash
sudo systemctl restart nginx
```

---

### FASE 6: GENERACIÓN DE CERTIFICADO SSL (CERTBOT)

Duración estimada: 5 minutos

#### 6.1 Solicitar certificado

```bash
sudo certbot --nginx -d buscobien.net -d api.buscobien.com -d n8n.buscobien.com
```

Certbot preguntará:

1. Correo electrónico para renovaciones
2. Aceptar términos de servicio
3. Compartir correo con EFF (opcional)
4. Redirigir HTTP a HTTPS (seleccionar opción 2)

#### 6.2 Verificar certificado

```bash
sudo certbot certificates
```

#### 6.3 Verificar renovación automática

```bash
sudo systemctl status certbot.timer
sudo certbot renew --dry-run
```

---

### FASE 7: DESPLIEGUE DE ARCHIVOS FLUTTER WEB (WASM)

Duración estimada: 10 minutos

#### 7.1 Crear directorio

```bash
sudo mkdir -p /var/www/buscobien_web
sudo chown www-data:www-data /var/www/buscobien_web
```

#### 7.2 Copiar archivos compilados

```bash
# Desde máquina local
scp -r build/web/ usuario@100.67.186.46:/var/www/buscobien_web/
```

#### 7.3 Ajustar permisos

```bash
ssh usuario@100.67.186.46
sudo chown -R www-data:www-data /var/www/buscobien_web
sudo chmod -R 755 /var/www/buscobien_web
```

#### 7.4 Verificar

```bash
curl -I https://buscobien.net/
```

---

### FASE 8: PRUEBAS DE INTEGRACIÓN

Duración estimada: 20 minutos

#### 8.1 Prueba de login (obtener JWT)

```bash
curl -X POST https://api.buscobien.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"USUARIO_VALIDO","password": ""}'
```

Resultado esperado:

```json
{
  "token": "eyJhbG...9..."
}
```

#### 8.2 Prueba de acceso a CouchDB con JWT

```bash
TOKEN="eyJhbG...9..."

curl -H "Authorization: Bearer " \
  https://api.buscobien.com/api/_session
```

Resultado esperado:

```json
{
  "ok": true,
  "userCtx": {
    "name": "USUARIO_VALIDO",
    "roles": [...]
  }
}
```

#### 8.3 Prueba de acceso sin token (debe fallar)

```bash
curl https://api.buscobien.com/api/_all_dbs
```

Resultado esperado: `401 Unauthorized`

#### 8.4 Prueba de rate limiting

```bash
for i in {1..30}; do
  curl -s -o /dev/null -w "%{http_code}\n" https://api.buscobien.com/api/_session
done
```

Resultado esperado: Primeras ~20 peticiones → 401/200, siguientes → 503 (rate limit)

#### 8.5 Prueba de seguridad (CouchDB no expuesto)

```bash
# Desde internet (fuera del servidor)
curl http://100.67.186.46:5984
```

Resultado esperado: Timeout o rechazo (no debe responder)

---

### FASE 9: MONITOREO Y LOGGING

Duración estimada: 10 minutos

#### 9.1 Configurar rotación de logs

```bash
sudo nano /etc/logrotate.d/buscobien-auth
```

Contenido:

```
/opt/auth-service/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 auth-service auth-service
}
```

#### 9.2 Verificar logs de servicios

```bash
# Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Auth Service
sudo journalctl -u auth-service -f

# CouchDB
sudo journalctl -u couchdb -f
```

#### 9.3 Configurar alertas (opcional)

```bash
# Instalar monit
sudo apt install monit
```

---

### FASE 10: DOCUMENTACIÓN Y HANDOVER

Duración estimada: 15 minutos

#### 10.1 Documentar credenciales y rutas

Crear documento (4/5)
[14/09/2026 04:12 p. m.] AsistenteAM: `/opt/buscobien-security-readme.md` con:

- URLs de servicios
- Puertos internos
- Rutas de llaves (NO las llaves mismas)
- Procedimiento de rotación de certificados
- Procedimiento de rotación de llaves RSA

#### 10.2 Crear script de backup de llaves

```bash
#!/bin/bash
# /opt/backup-auth-keys.sh
BACKUP_DIR="/opt/backups/auth-keys"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Copiar llaves (con permisos correctos)
cp /opt/auth-service/private.pem $BACKUP_DIR/private_$DATE.pem
chmod 400 $BACKUP_DIR/private_$DATE.pem

cp /opt/auth-service/public.pem $BACKUP_DIR/public_$DATE.pem
chmod 644 $BACKUP_DIR/public_$DATE.pem

echo "Backup completado: $BACKUP_DIR"
```

---

## ✅ CHECKLIST FINAL DE VERIFICACIÓN

Nginx corriendo
• Estado esperado: Active (running)
• Comando de verificación: `sudo systemctl status nginx`

Certificado SSL válido
• Estado esperado: Válido y vigente
• Comando de verificación: `sudo certbot certificates`

Auth Service corriendo
• Estado esperado: Active (running)
• Comando de verificación: `sudo systemctl status auth-service`

CouchDB con JWT
• Estado esperado: Configurado y corriendo
• Comando de verificación: `sudo systemctl status couchdb`

Login devuelve JWT
• Estado esperado: JSON con token
• Comando de verificación: `curl -X POST https://api.buscobien.com/api/login`

CouchDB valida JWT
• Estado esperado: Sesión autenticada
• Comando de verificación: `curl -H "Authorization: Bearer " https://api.buscobien.com/api/_session`

CouchDB no expuesto
• Estado esperado: No responde en 5984 desde internet
• Comando de verificación: `curl http://100.67.186.46:5984`

Rate limiting activo
• Estado esperado: 503 después de burst
• Comando de verificación: `for i in {1..30}; do curl ...; done`

Firewall configurado
• Estado esperado: UFW activo con reglas
• Comando de verificación: `sudo ufw status`

Logs rotando
• Estado esperado: Logrotate configurado
• Comando de verificación: `sudo logrotate -d /etc/logrotate.d/buscobien-auth`

---

## 🔒 CONSIDERACIONES DE SEGURIDAD CRÍTICAS

1. Llave privada (private.pem):
   - PERMISOS: 400 (solo lectura propietario)
   - UBICACIÓN: `/opt/auth-service/private.pem`
   - NUNCA copiar fuera del servidor
   - Rotar anualmente

2. CouchDB bind:
   - Siempre en `127.0.0.1`
   - Acceso solo vía Nginx proxy
   - Verificar con `ss -tlnp | grep 5984`

3. Certificados SSL:
   - Renovación automática via certbot timer
   - Verificar con `sudo certbot renew --dry-run`

4. Rate limiting:
   - Ajustar `rate=10r/s` según tráfico real
   - Monitorear logs de Nginx para detectar abuse

5. VPN/Tailscale:
   - Qdrant solo accesible desde red VPN
   - Actualizar `allow 100.67.186.0/24` según tu subnet

---

📊 TIEMPOS ESTIMADOS TOTALES

Fase 0: Prerrequisitos
• Tiempo: 15 min

Fase 1: Nginx + Certbot
• Tiempo: 10 min

Fase 2: Llaves RSA
• Tiempo: 5 min

Fase 3: CouchDB JWT
• Tiempo: 10 min

Fase 4: Auth Service
• Tiempo: 20 min

Fase 5: Nginx Config
• Tiempo: 15 min

Fase 6: SSL Certbot
• Tiempo: 5 min

Fase 7: Flutter Deploy
• Tiempo: 10 min

Fase 8: Pruebas
• Tiempo: 20 min

Fase 9: Monitoreo
• Tiempo: 10 min

Fase 10: Documentación
• Tiempo: 15 min

TOTAL
• Tiempo: ~2 horas

---

ESTADO ACTUAL: PLAN GENERADO - NO EJECUTADO  
PRÓXIMO PASO:\* Confirmación para comenzar ejecución fase por fase. (5/5)
