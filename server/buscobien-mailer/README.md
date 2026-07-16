# buscobien-mailer

Microservicio Node.js para envío de correos de recuperación de contraseña.

## Requisitos

- Node.js 18+
- Cuenta SMTP (Gmail, Mailgun, tu propio servidor, etc.)
- pm2 instalado globalmente (`npm install -g pm2`)

## Instalación en el servidor

```bash
# 1. Subir la carpeta al servidor
scp -P 7822 -r server/buscobien-mailer deploy@190.92.151.34:~/buscobien-mailer

# 2. Conectarse al servidor
ssh miservidor

# 3. Instalar dependencias
cd ~/buscobien-mailer
npm install

# 4. Crear .env a partir del ejemplo
cp .env.example .env
nano .env   # Editar con tus credenciales SMTP reales
```

## Variables de entorno (`.env`)

| Variable | Descripción |
|---|---|
| `PORT` | Puerto del servicio (default: 3001) |
| `SMTP_HOST` | Host del servidor SMTP |
| `SMTP_PORT` | Puerto SMTP (587 para TLS, 465 para SSL) |
| `SMTP_USER` | Usuario SMTP |
| `SMTP_PASS` | Contraseña SMTP |
| `SMTP_FROM` | Remitente visible (ej: `"BuscoBien <noreply@buscobien.net>"`) |
| `DEEP_LINK_BASE` | URL base del deep link (ej: `https://buscobien.net/recuperar`) |

## Ejecutar con pm2

```bash
# Iniciar
pm2 start server.js --name buscobien-mailer

# Ver estado
pm2 status

# Ver logs
pm2 logs buscobien-mailer

# Reiniciar automáticamente al arrancar el servidor
pm2 startup
pm2 save
```

## Configurar Apache como reverse proxy

Agregar en la configuración de Apache (ej: `/etc/apache2/sites-available/buscobien.conf`):

```apache
ProxyPass /api/mailer http://localhost:3001/api
ProxyPassReverse /api/mailer http://localhost:3001/api
```

Habilitar módulos requeridos:
```bash
sudo a2enmod proxy proxy_http
sudo systemctl reload apache2
```

## Probar el endpoint

```bash
curl -X POST http://localhost:3001/api/enviar-correo-recuperacion \
  -H "Content-Type: application/json" \
  -d '{
    "email": "prueba@ejemplo.com",
    "nombreUsuario": "UsuarioPrueba",
    "resetToken": "abc123",
    "perfil": "Usuario"
  }'
```

Respuesta esperada: `{"success":true,"message":"Correo enviado"}`
