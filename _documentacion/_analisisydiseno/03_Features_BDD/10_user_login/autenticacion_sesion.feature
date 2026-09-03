# language: es
Característica: Autenticación, Sesión, Registro y Recuperación

  Como usuario de Buscobien
  Quiero acceder seguro con mi rol (usuario/promotor/propietario)
  Y recuperar mi contraseña si la olvido

  Antecedentes:
    Dado que SessionNotifier (@riverpod) centraliza AuthState unificado
    Y SessionStorage factory elige secure_storage (móvil) o shared_preferences (web)
    Y 3 DBs CouchDB: usuarios, usuarios_promotores, usuarios_propietarios

  Escenario: Login exitoso con hash SHA-256 y secure storage
    Dado que usuario ingresa user/pass en LoginPage + selecciona tipo "Promotor"
    Cuando _handleLogin() ejecuta
    Entonces getUserIdNamePassByName() valida credenciales vs CouchDB
    Y deleteLocalSessionData() limpia almacenamiento previo
    Y getUserDataByNameInSessionData() carga datos completos usuario
    Y guarda en storage: userId, userName, nombrePerfil, userPassHash (SHA-256)
    Y recupera avatar via ClassUserAvatarProvider
    Y navega a PrincipalSliversMenuInicial

  Escenario: Registro nuevo usuario con TyC/Privacidad PDF
    Dado que usuario completa RegisterScreenUsers (12 campos)
    Cuando valida pass == confirmPass y acepta TyC/Privacidad (checkboxes)
    Entonces hashea SHA256(userId + pass) como _id CouchDB
    Y verifica duplicado en DB correspondiente (promotor/propietario/usuario)
    Y guarda documento con campos extra (RFC, inmobiliaria, contadores si promotor)
    Y muestra visor PDF TyC/Privacidad desde assets (open_filex/url_launcher)

  Escenario: Recuperación password vía email + token 1h
    Dado que usuario en PageSolicitarRecuperacion ingresa email + selecciona perfil
    Cuando buscaUsuarioPorCorreo() (Mango query) encuentra usuario
    Entonces generateResetToken() → SHA256(UUIDv4)
    Y expiry = UTC+1h ISO8601
    Y guarda en buscobien_recuperacion_contrasena
    Y enviáCorreoRecuperacion() llama Node.js mailer (citigov.cloud:3001)

  Escenario: Cambio password con token deep link validado
    Dado que usuario accede /cambiopassword?token=abc&perfil=promotor
    Cuando validarToken() confirma token existe, no expirado, coincide perfil
    Entonces permite formulario nuevo password con strength meter
    Y actualizarPassword() hashea nuevo pass y actualiza en CouchDB

  Escenario: Avatar gestión (subida, preview, base64, PUT CouchDB)
    Dado que usuario en GestionAvatares selecciona imagen (FilePicker)
    Cuando previsualiza y confirma
    Entonces codifica base64 + contentType
    Y ClassUserAvatarProvider.guardaArchivoAvatar() PUT nativo a CouchDB
    Y recuperaDatosDelAvatar() GET vista para mostrar

  Escenario: Restauración sesión al reiniciar app
    Dado que app inicia con sesión previa
    Cuando SessionNotifier.getSessionValuesFromLocalStorage() ejecuta
    Entonces reconstruye AuthState completo desde storage
    Y setPerfilUsuarioByNombrePerfil() setea 9 flags roles (switch)
    Y isAuthenticated = true sin re-login