# language: es
Funcionalidad: Pantalla Perfil de usuario

  Como usuario autenticado
  Quiero ver mi perfil (avatar, nombre, rol, datos de contacto) y editar/actualizar
  Para gestionar mi identidad pública en Buscobien

  Antecedentes:
    Dado que el usuario accede a la sección "Perfil" (índice 4) de PrincipalSliversMenuInicial
    Y la aplicación usa ConsumerStatefulWidget + ref.watch(sessionProvider) para detectar sesión

  Escenario: Usuario no logueado ve CTA de login
    Dado que sessionProvider indica isUserLoggedIn == false
    Cuando PaginaPerfilWidget se renderiza
    Entonces muestra _buildNoUserView con ícono Symbols.person
    Y mensaje "Inicia sesión" + CTA "Ingresar" que navega a AppRoutes.login

  Escenario: Usuario logueado ve su perfil completo
    Dado que sessionProvider retorna datos válidos (userId, userName, nombrePerfil, avatar base64)
    Cuando _buildUserProfileView se construye
    Entonces _buildHeaderSection renderiza avatar (Image.memory) + nombre + rol
    Y _buildInfoCard renderiza datos de contacto (email, celular, RFC si promotor)
    Y CTAs "Editar perfil" y "Gestión avatar" aparecen

  Escenario: Recuperación del avatar en initState
    Dado que la app abre por primera vez y vuelve al perfil
    Cuando initState dispara postFrameCallback
    Entonces se invoca recuperaDatosDelAvatar(userId) para cargar el avatar base64
    Y se muestra si ya estaba en sesión
    Y si falla o está vacío, fallback a CircleAvatar con Symbols.person

  Escenario: Logout actualiza perfil a vista no-logueado
    Dado que el usuario hace logout desde otra pantalla
    Cuando sessionProvider.notifier.logout ejecuta
    Entonces PaginaPerfilWidget reconstruye (ref.watch reactivo)
    Y pasa de _buildUserProfileView a _buildNoUserView inmediatamente

  Escenario: CTA Editar perfil
    Dado que el usuario toca "Editar perfil"
    Cuando se dispara el callback
    Entonces navega a la pantalla de registro (10_user_login) en modo edición
    Y los campos se pre-cargan con los datos del usuario actual

  Escenario: CTA Gestión Avatar
    Dado que el usuario toca "Gestión avatar"
    Cuando se dispara el callback
    Entonces navega a GestionAvatares (10_user_login) con FilePicker + base64
    Y al regresar, el avatar en sesión se actualiza

  Escenario: Sesión en estado parcial (nombre null, etc)
    Dado que el sessionProvider retornó datos incompletos
    Cuando _buildProfileRow(label, value="null") se renderiza
    Entonces muestra el texto "null" como string (deuda — debería validar y mostrar "Sin dato")
