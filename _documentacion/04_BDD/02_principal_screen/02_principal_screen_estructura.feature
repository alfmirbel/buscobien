# language: es
Característica: Estructura y Enrutamiento de la Pantalla Principal
  Como usuario de BuscoBien
  Quiero que la pantalla principal me muestre la sección correcta según mi navegación
  Para moverme fluídamente entre Inicio, Propiedades, Ubicación, Mi Cuenta y Perfil

  Escenario: La pantalla principal muestra la sección de Inicio al arrancar
    Dado que el usuario acaba de iniciar la aplicación
    Y el estado de navegación tiene "indiceInicial = 0"
    Cuando se renderiza "PrincipalSliversMenuInicial"
    Entonces el sistema debe mostrar la vista "PageInicio" como contenido principal
    Y el menú superior "menuSuperiorMenuInicial" debe estar visible
    Y no debe mostrar el menú secundario de propiedades

  Escenario: El usuario navega a la sección de Propiedades
    Dado que el usuario está en la sección "Inicio"
    Cuando el usuario selecciona "Propiedades" en el menú inicial
    Entonces el estado "indiceInicial" debe cambiar a "1"
    Y el sistema debe mostrar "menuSuperiorMenuPrincipal" como sub-menú
    Y el contenido debe cambiar a "PaginaBuscaEspacios"

  Escenario: El usuario navega a la sección de Ubicación
    Dado que el usuario está en cualquier sección de la pantalla principal
    Cuando el usuario selecciona "Ubicación" en el menú inicial
    Entonces el estado "indiceInicial" debe cambiar a "2"
    Y el sistema debe mostrar "PaginaPrincipalListaLocalidades"

  Escenario: El usuario navega a la sección de Perfil
    Dado que el usuario está en cualquier sección de la pantalla principal
    Cuando el usuario selecciona "Perfil" en el menú inicial
    Entonces el estado "indiceInicial" debe cambiar a "4"
    Y el sistema debe mostrar "PaginaPerfilWidget"

  Escenario: El scroll regresa al inicio al cambiar de sección
    Dado que el usuario ha hecho scroll hacia abajo en una sección
    Cuando el usuario cambia a una sección diferente del menú inicial
    Entonces el sistema debe desplazar el scroll al inicio automáticamente
    Y el contenido de la nueva sección debe aparecer desde el principio

  Escenario: La pantalla principal se adapta a pantallas anchas
    Dado que el usuario abre la aplicación en una tablet o escritorio
    Cuando se renderiza "PrincipalSliversMenuInicial"
    Entonces el sistema debe mostrar el contenido en un layout de fila ("Row")
    Y el cuerpo principal debe ocupar el espacio restante después de la barra de aplicación
