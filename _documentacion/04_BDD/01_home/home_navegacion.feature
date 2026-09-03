# language: es

Característica: Navegación Principal de la Aplicación (HomeNavigation)
  Como usuario de BuscoBien
  Quiero que la aplicación recuerde en qué sección del menú me encuentro
  Para que la interfaz refleje siempre mi posición de navegación actual de forma reactiva

  Antecedentes:
    Dado que la aplicación está iniciada
    Y el estado de navegación inicial es "indiceInicial = 0" (Inicio)

  # ---------------------------------------------------------------------------
  # MENÚ INICIAL (NavigationBar superior de pestañas)
  # ---------------------------------------------------------------------------
  Escenario: Visualización del contenido de inicio al arrancar la app
    Dado que el usuario está en la pantalla principal
    Cuando la aplicación termina de cargar
    Entonces el índice de menú inicial debe ser "0" (Inicio / Landing Page)
    Y la pantalla debe mostrar el contenido de "PageInicio"
    Y el menú superior debe mostrar la pestaña "Inicio" seleccionada con el color primario M3

  Escenario: El usuario navega a la sección "Propiedades" (índice 1)
    Dado que el usuario está en la sección "Inicio" (índice 0)
    Cuando el usuario presiona la pestaña "Propiedades" en el menú inicial
    Entonces el sistema debe llamar a "actualizarInicial(1)"
    Y el estado "indiceInicial" debe actualizarse a "1"
    Y el contador de versión "version" debe incrementarse en "1"
    Y la pantalla debe mostrar el menú secundario "menuSuperiorMenuPrincipal"
    Y el contenido debe cambiar a "PaginaBuscaEspacios"

  Escenario: El usuario navega a la sección "Ubicación" (índice 2)
    Dado que el usuario está en cualquier sección
    Cuando el usuario presiona la pestaña "Ubicación"
    Entonces el estado "indiceInicial" debe actualizarse a "2"
    Y la pantalla debe mostrar "PaginaPrincipalListaLocalidades"

  Escenario: Acceso a "Mi Cuenta" sin sesión iniciada (estado invitado)
    Dado que el usuario no ha iniciado sesión (nombrePerfil = "")
    Cuando el usuario presiona la pestaña "Mi Cuenta" (índice 3)
    Entonces el estado "indiceInicial" debe actualizarse a "3"
    Y la pantalla debe mostrar el mensaje "Crea listas, grupos o contactos"
    Y debe aparecer el botón "Ingresa de acuerdo a tu perfil" con borde de color primario M3
    Y al tocar ese botón debe abrirse el diálogo "dialogBoxFichaLogin"

  Escenario: Acceso a "Mi Cuenta" como Promotor autenticado
    Dado que el usuario ha iniciado sesión con perfil "Promotor"
    Cuando el usuario presiona la pestaña "Mi Cuenta" (índice 3)
    Entonces el estado "indiceInicial" debe actualizarse a "3"
    Y la pantalla debe mostrar el sub-menú "MenuSuperiorPaginaTuCuenta"
    Y las pestañas disponibles deben ser "Espacios", "Listas", "Grupos" y "Conocidos"

  Escenario: Acceso a "Mi Cuenta" como Usuario (comprador) autenticado
    Dado que el usuario ha iniciado sesión con perfil "Usuario"
    Cuando el usuario presiona la pestaña "Mi Cuenta" (índice 3)
    Entonces el estado "indiceInicial" debe actualizarse a "3"
    Y la pantalla debe mostrar el sub-menú "MenuSuperiorPaginaTuCuentaUsuario"
    Y las pestañas disponibles deben ser "Listas", "Grupos" y "Conocidos"

  Escenario: El usuario navega a la sección "Perfil" (índice 4)
    Dado que el usuario está en cualquier sección
    Cuando el usuario presiona la pestaña "Perfil"
    Entonces el estado "indiceInicial" debe actualizarse a "4"
    Y la pantalla debe mostrar "PaginaPerfilWidget"

  # ---------------------------------------------------------------------------
  # SUB-MENÚ PRINCIPAL (Propiedades)
  # ---------------------------------------------------------------------------
  Escenario: El usuario filtra propiedades por tipo en el sub-menú principal
    Dado que el usuario está en la sección "Propiedades" (índice 1)
    Y el sub-índice principal actual es "0" (Todas)
    Cuando el usuario presiona la pestaña "Casas" en el menú principal
    Entonces el sistema debe llamar a "actualizarPrincipal(1)"
    Y el estado "indicePrincipal" debe actualizarse a "1"
    Y el counter "version" debe incrementarse
    Y el contenido debe refiltrarse para mostrar únicamente propiedades del tipo "Casas"

  Escenario: Persistencia reactiva del índice de nivel de gobierno
    Dado que el usuario selecciona el filtro "Municipal" en el menú de nivel de gobierno
    Cuando el sistema llama a "actualizarNivelGobierno(2)"
    Entonces el estado "indiceNivelGobierno" debe actualizarse a "2"
    Y el contenido visible de propiedades debe reflejar el ámbito "Municipal"

  # ---------------------------------------------------------------------------
  # MI CUENTA — SUB-SECCIONES DEL PROMOTOR
  # ---------------------------------------------------------------------------
  Escenario: El promotor navega a "Mis Espacios" dentro de Mi Cuenta
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando presiona la pestaña "Espacios" (indiceMiCuenta = 0)
    Entonces el sistema debe llamar a "actualizarMiCuenta(0)"
    Y la pantalla debe mostrar "PaginaTusEspacios"

  Escenario: El promotor navega a "Mis Listas" dentro de Mi Cuenta
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando presiona la pestaña "Listas" (indiceMiCuenta = 1)
    Entonces el sistema debe llamar a "actualizarMiCuenta(1)"
    Y la pantalla debe mostrar "PageMisListas"

  Escenario: El promotor navega a "Mis Grupos" dentro de Mi Cuenta
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando presiona la pestaña "Grupos" (indiceMiCuenta = 2)
    Entonces la pantalla debe mostrar "GruposView" con el userId y userName del promotor

  Escenario: El promotor navega a "Mis Conocidos" dentro de Mi Cuenta
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando presiona la pestaña "Conocidos" (indiceMiCuenta = 3)
    Entonces la pantalla debe mostrar "ConocidosView" con el userId y userName del promotor

  # ---------------------------------------------------------------------------
  # SCROLL Y REACTIVIDAD
  # ---------------------------------------------------------------------------
  Escenario: El scroll regresa al inicio al cambiar de sección
    Dado que el usuario ha hecho scroll hacia abajo en cualquier sección
    Cuando cambia a una sección diferente del menú
    Entonces el ScrollController debe ejecutar "jumpTo(0)"
    Y el contenido de la nueva sección debe aparecer desde el principio

  Escenario: El campo "version" garantiza reconstrucción de widgets
    Dado que el estado actual tiene "version = 5"
    Cuando cualquier método "actualizar*()" es invocado
    Entonces la propiedad "version" debe incrementarse a "6"
    Y Riverpod debe notificar a todos los widgets que observan "homeNavigationProvider"

  # ---------------------------------------------------------------------------
  # INTEROPERABILIDAD CON LA UBICACIÓN GEOGRÁFICA
  # ---------------------------------------------------------------------------
  Escenario: La app detecta automáticamente la ubicación al iniciar
    Dado que la aplicación acaba de arrancar
    Y el usuario concede permiso de ubicación
    Cuando el sistema determina el código postal del usuario
    Entonces el sistema debe llamar a "actualizarNivelGobierno(3)" (Código Postal)
    Y el menú de nivel de gobierno debe mostrar la pestaña "C.P." como activa
    Y las propiedades mostradas deben filtrarse al código postal detectado
