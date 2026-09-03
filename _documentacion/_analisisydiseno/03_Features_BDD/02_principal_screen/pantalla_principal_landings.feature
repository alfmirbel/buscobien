# language: es
Característica: Pantalla Principal y Landing Pages

  Como usuario de Buscobien
  Quiero un shell principal con navegación por secciones y landing pages por actor
  Para descubrir y acceder a funcionalidades según mi rol

  Antecedentes:
    Dado que PrincipalSliversMenuInicial orquesta 7 menús con TabControllers
    Y homeNavigationProvider trackea 7 índices de navegación
    Y 9 landing pages (03_vistas) pre-configuran providers y navegan a principal

  Escenario: Shell principal con 5 secciones principales
    Dado que el usuario está en /principal
    Cuando homeNavigationProvider.indiceInicial = 0
    Entonces muestra PageInicio (hero + 3 tarjetas: Buscar, Promotores, Propietarios)
    Cuando indiceInicial = 1
    Entonces muestra búsqueda propiedades con filtros sliver
    Cuando indiceInicial = 2
    Entonces muestra ubicación (SEPOMEX + GMaps)
    Cuando indiceInicial = 3
    Entonces muestra Mi Cuenta (Grupos/Conocidos según rol)
    Cuando indiceInicial = 4
    Entonces muestra Perfil

  Escenario: AppBar dinámico según sesión
    Dado que el usuario tiene sesión activa
    Cuando renderiza appBarPrincipal
    Entonces muestra botón avatar (toca → navega a perfil/mi cuenta)
    Y botones: favoritos, búsqueda, notificaciones, menú
    Dado que NO hay sesión
    Cuando renderiza appBarPrincipal
    Entonces muestra botón "Login" abre dialogBoxFichaLogin

  Escenario: Drawer lateral con 11 items
    Dado que el usuario abre MenuDrawer
    Cuando ve la lista
    Entonces ve: Salir, Principal, Favoritos, Ver después, Preferencias, Configuración, Acerca de, Contacto
    Y items "Próximamente" sin navegación real

  Escenario: Landing page pre-configura providers y navega
    Dado que usuario está en pagina_promotores.dart
    Cuando toca "Publicar"
    Entonces configura menuTipoEspacio=Normales, menuTipoTransaccion=Venta, menuTuCuenta=Propiedades, menuNivelGobierno=Nacional
    Y navega a /principal con pushReplacementNamed

  Escenario: Landing page usuarios con búsqueda CP en vivo
    Dado que usuario está en pagina_usuarios.dart
    Cuando ingresa CP válido (5 dígitos) y toca "Buscar"
    Entonces valida CP, actualiza codigoPostalBusquedaProvider
    Y navega a búsqueda de localidades

  Escenario: 9 landings con branding propio y CTA variables
    Dado que cada pagina_*.dart usa paleta propia
    Cuando usuario ve Asociaciones (burdeos/dorado), Hospedaje (azul/ámbar), Inmobiliarias (steel blue/green)...
    Entonces cada una tiene hero, benefits, features, pasos, footer
    PERO solo 4/9 tienen CTA funcional (Promotores, Propietarios, Hospedaje, Usuarios)