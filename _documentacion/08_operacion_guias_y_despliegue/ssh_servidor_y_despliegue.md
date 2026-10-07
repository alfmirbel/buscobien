# Guía de Infraestructura, SSH y Despliegue en Servidor — BuscoBien

**Fase de SDLC:** Etapa 8 — Operación, Guías y Despliegue  
**Servidor:** IP `190.92.151.34` (Puerto SSH `7822`)  
**Última actualización:** 2026-09-29  

---

## 1. Conexión SSH al Servidor VPS

> [!IMPORTANT]  
> En Windows, la conexión SSH DEBE realizarse desde **PowerShell** (no mediante Bash/WSL) para poder interactuar correctamente con el `ssh-agent` nativo de Windows, ya que la clave privada contiene clave de paso (*passphrase*).

### Configuración en `~/.ssh/config`
```sshconfig
Host miservidor
    HostName 190.92.151.34
    Port 7822
    User deploy
    IdentityFile ~/.ssh/id_ed25519

Host miservidor-root
    HostName 190.92.151.34
    Port 7822
    User root
    IdentityFile ~/.ssh/id_ed25519
```

### Inicio de Sesión SSH en PowerShell
```powershell
# 1. Iniciar el servicio ssh-agent en Windows
Start-Service ssh-agent

# 2. Agregar la clave privada al agente
ssh-add $env:USERPROFILE\.ssh\id_ed25519

# 3. Verificar conexión con el servidor
ssh miservidor "echo ok"
```

---

## 2. Microservicios y Procesos en el Servidor (PM2 & Apache)

- **CouchDB**: Escuchando en `https://citigov.cloud:6984` (Base de datos remota con puerto SSL).
- **Node.js API (objetivo, pendiente)**: repositorio separado que será responsable de la autenticación JWT y del acceso a CouchDB con `nano`, detrás de nginx. Hoy el cliente Flutter accede directamente a CouchDB (ver [`arquitectura_c4.md`](../04_arquitectura_y_diseno/arquitectura_c4.md)).
- **Mailer Microservice**: Ubicado en `server/buscobien-mailer/` (Node.js) ejecutándose mediante **PM2** en segundo plano bajo Apache reverse proxy.

### Comandos Frecuentes de Gestión PM2
```bash
# Ver estado de los microservicios en el servidor
pm2 status

# Reiniciar el servicio de correo
pm2 restart buscobien-mailer

# Inspeccionar logs en tiempo real
pm2 logs buscobien-mailer
```

---

## 3. Comandos de Compilación y Despliegue de la App Flutter

### Compilación para Desarrollo Web
```powershell
flutter run -d chrome --wasm --dart-define-from-file=defines.json
```

### Compilación para Producción Web (WASM)
```powershell
flutter build web --wasm --dart-define-from-file=defines.json
```

### Compilación para Windows
```powershell
flutter run -d windows --dart-define-from-file=defines.json
```

> [!CAUTION]  
> La bandera `--wasm` es **obligatoria** para compilación Web. Compilar Web sin `--wasm` o sin `--dart-define-from-file=defines.json` generará fallos de autenticación con CouchDB y mapas.
