# language: es
Característica: Navegación y CTAs de las Landing Pages
  Como usuario final
  Quiero acceder a las funcionalidades principales desde las landing pages
  Para comenzar a usar la aplicación según mi perfil

  Escenario: El CTA principal de la landing page de Búsqueda navega a Propiedades
    Dado que el usuario está en la landing page de "Buscar"
    Cuando el usuario presiona el botón "Publicar" en la AppBar
    Entonces el sistema debe cambiar "menuInicial" a 1 (Propiedades)
    Y "menuPrincipal" a 0 (Todas)
    Y "nivelGobierno" a 0 (Federal)
    Y "tipoEspacio" a 0
    Y "tipoTransaccion" a 0
    Y debe navegar a "AppRoutes.principal" reemplazando la ruta actual

  Escenario: El CTA "Iniciar" de la landing page de Promotores abre el login
    Dado que el usuario está en la landing page de "Promotores"
    Cuando el usuario presiona "Iniciar"
    Entonces el sistema debe abrir "dialogBoxFichaLogin"
    Y si el login es exitoso debe navegar a "Mi Cuenta" (índice 3)
    Y si el login es cancelado debe navegar a "Propiedades" (índice 1)

  Escenario: El CTA "Publicar" de la landing page de Promotores navega a Publicar
    Dado que el usuario está en la landing page de "Promotores"
    Cuando el usuario presiona el botón "Publicar" en la AppBar
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: El CTA "Acceder" de la landing page de Propietarios navega a Publicar
    Dado que el usuario está en la landing page de "Propietarios"
    Cuando el usuario presiona "Acceder"
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: El CTA "Publicar Gratis Ahora" de Propietarios navega a Publicar
    Dado que el usuario está en la landing page de "Propietarios"
    Cuando el usuario presiona "Publicar Gratis Ahora" en el Hero
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: El CTA "Inicia" de la landing page de Anfitriones navega a Publicar
    Dado que el usuario está en la landing page de "Anfitriones" (Hospedaje)
    Cuando el usuario presiona "Inicia" en la AppBar
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: El CTA "Publicar mi Propiedad" de Anfitriones navega a Publicar
    Dado que el usuario está en la landing page de "Anfitriones"
    Cuando el usuario presiona "Publicar mi Propiedad" en el Hero
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: Los botones "PROXIMAMENTE" no ejecutan navegación
    Dado que el usuario está en una landing page con botones "PROXIMAMENTE"
    Cuando el usuario presiona cualquiera de esos botones
    Entonces el sistema no debe navegar a ninguna pantalla
    Y no debe mostrar errores

  Escenario: El botón "Prueba Gratis" de Promotores navega a Publicar
    Dado que el usuario está en la landing page de "Promotores"
    Cuando el usuario presiona "Prueba Gratis"
    Entonces el sistema debe navegar a "AppRoutes.principal"
    Y debe posicionar el menú en "Propiedades" (índice 1) y "Publicar" (índice 5)

  Escenario: La landing page de Inmobiliarias muestra botones sin acción
    Dado que el usuario abre la landing page de "Inmobiliarias"
    Cuando el usuario presiona "PROXIMAMENTE REGISTRO"
    Entonces el sistema no debe ejecutar ninguna navegación
    Y debe mantener la landing page visible

  Escenario: La navegación desde landing pages usa pushReplacementNamed
    Dado que el usuario está en cualquier landing page
    Cuando el usuario presiona un CTA que navega a la app principal
    Entonces el sistema debe usar "pushReplacementNamed"
    Y no debe permitir regresar a la landing page con el botón atrás
