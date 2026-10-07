# language: es
Característica: Deep link de recuperación de contraseña
  Como usuario que olvidó su contraseña
  Quiero abrir el enlace que recibí por correo
  Para llegar directamente a la pantalla de cambio de contraseña

  @REQ-ROUT-015
  Escenario: El manejador de deep links se inicializa después del primer frame
    Cuando `BuscoBienApp` termina de dibujar su primer frame
    Entonces se invoca `initDeepLinkHandler(navigatorKey)` una sola vez

  @REQ-ROUT-014
  Escenario: La navegación del deep link usa el navigatorKey global
    Dado que `MaterialApp` usa el `navigatorKey` global
    Cuando el manejador procesa un enlace válido
    Entonces navega con `navigatorKey.currentState?.pushNamed` sin necesitar un `BuildContext`

  @REQ-ROUT-007
  Escenario: Enlace válido de recuperación
    Dado que llega la URI "https://buscobien.net/recuperar?token=abc123&perfil=promotor"
    Cuando el manejador la procesa
    Entonces navega a "/cambiopassword"
    Y envía los argumentos {"token": "abc123", "perfil": "promotor"}

  @REQ-ROUT-007
  Escenario: El enlace funciona también en un host de desarrollo
    Dado que llega la URI "http://localhost:8080/recuperar?token=abc123&perfil=usuario"
    Cuando el manejador la procesa
    Entonces navega a "/cambiopassword" porque solo se comprueba que el path contenga "/recuperar"

  @REQ-ROUT-007
  Escenario: Falta el parámetro token
    Dado que llega la URI "https://buscobien.net/recuperar?perfil=promotor"
    Cuando el manejador la procesa
    Entonces ignora el enlace sin navegar ni mostrar mensaje

  @REQ-ROUT-007
  Escenario: El parámetro perfil está vacío
    Dado que llega la URI "https://buscobien.net/recuperar?token=abc123&perfil="
    Cuando el manejador la procesa
    Entonces ignora el enlace sin navegar

  @REQ-ROUT-007
  Escenario: Un enlace con otro path se ignora
    Dado que llega la URI "https://buscobien.net/propiedades?token=abc123&perfil=promotor"
    Cuando el manejador la procesa
    Entonces ignora el enlace

  @REQ-ROUT-008
  Escenario: En Web solo se evalúa la URL al arrancar
    Dado que la aplicación se ejecuta en Web
    Cuando la app inicia con la URL "/recuperar?token=abc123&perfil=promotor"
    Entonces se evalúa `Uri.base` una vez
    Y no se escuchan cambios posteriores de URL

  @REQ-ROUT-008
  Escenario: En móvil o escritorio se atienden el enlace inicial y los siguientes
    Dado que la aplicación no se ejecuta en Web
    Cuando la app se abre desde un enlace (arranque en frío)
    Entonces se procesa el enlace de `AppLinks().getInitialLink()`
    Y mientras la app esté activa se procesan los enlaces de `AppLinks().uriLinkStream`
