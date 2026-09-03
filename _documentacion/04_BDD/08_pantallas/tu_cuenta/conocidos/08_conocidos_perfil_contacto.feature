# language: es
Característica: Perfil de Contacto y sus Publicaciones
  Como usuario autenticado
  Quiero ver el perfil público de un contacto y sus propiedades publicadas
  Para conocer su actividad en la plataforma

  Escenario: El perfil muestra el nombre y avatar del contacto
    Dado que el usuario navega a "PagePerfilContacto" con contactoId "user:456" y nombre "María"
    Cuando se renderiza la pantalla
    Entonces el sistema debe mostrar un "CircleAvatar" con la inicial "M" y radio 40
    Y debe mostrar el nombre "María" en texto bold de tamaño 22
    Y el header debe tener color de fondo "appTheme.primary.withValues(alpha: 0.05)"

  Escenario: El perfil carga las propiedades del contacto
    Dado que el usuario está en "PagePerfilContacto"
    Cuando se monta la pantalla
    Entonces el sistema debe ejecutar "propiedadesContactoProvider(contactoId)"
    Y debe mostrar "CircularProgressIndicator" mientras carga

  Escenario: El perfil muestra error si falla la carga de propiedades
    Dado que el usuario está en "PagePerfilContacto"
    Cuando "propiedadesContactoProvider" emite "error"
    Entonces el sistema debe mostrar el texto "Error: $err" centrado

  Escenario: El perfil muestra estado vacío si no hay propiedades
    Dado que el contacto no tiene propiedades publicadas
    Cuando se renderiza la lista de propiedades
    Entonces el sistema debe mostrar el texto "Este usuario no tiene propiedades publicadas."
    Y no debe mostrar tarjetas de propiedades

  Escenario: Las propiedades se muestran en un grid de 2 columnas
    Dado que el contacto tiene propiedades publicadas
    Cuando se renderiza la lista
    Entonces el sistema debe mostrar un "GridView.builder" con "crossAxisCount: 2"
    Y cada propiedad debe tener "crossAxisSpacing: 10" y "mainAxisSpacing: 10"

  Escenario: Cada propiedad muestra imagen, título y precio
    Dado que el contacto tiene propiedades publicadas
    Cuando se renderiza una tarjeta de propiedad
    Entonces el sistema debe mostrar un contenedor con icono "Symbols.home" (placeholder)
    Y debe mostrar el "letreropromocional" como título (max 2 líneas)
    Y debe mostrar el precio en verde con formato "$ {precioventa}"

  Escenario: El AppBar muestra el nombre del contacto
    Dado que el usuario está en "PagePerfilContacto"
    Cuando se renderiza el AppBar
    Entonces el sistema debe mostrar el título "Perfil: {contactoName}"
    Y el AppBar debe usar "appBarSecondPage" con estilo secundario
