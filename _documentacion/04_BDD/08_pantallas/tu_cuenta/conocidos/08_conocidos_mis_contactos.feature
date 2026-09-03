# language: es
Característica: Gestión de Contactos Aceptados
  Como usuario autenticado
  Quiero ver mis contactos confirmados y acceder a su perfil o chat
  Para comunicarme con mi red de contactos

  Escenario: La pantalla carga los contactos al montar
    Dado que el usuario navega a "PageMisContactos"
    Cuando la pantalla se monta por primera vez
    Entonces el sistema debe ejecutar "conocidosProvider.notifier.cargar(currentUserId)"
    Y debe mostrar un "CircularProgressIndicator" centrado mientras carga

  Escenario: La pantalla muestra error si falla la carga de contactos
    Dado que el usuario está en "PageMisContactos"
    Cuando "conocidosAceptadosProvider" emite un estado "error"
    Entonces el sistema debe mostrar el icono "Symbols.cloud_off" en color "appTheme.error"
    Y debe mostrar el texto "Error al cargar contactos" en color "appTheme.error"
    Y debe mostrar un botón "Reintentar" que vuelve a llamar a "cargar(currentUserId)"

  Escenario: La pantalla muestra estado vacío cuando no hay contactos
    Dado que el usuario no tiene contactos confirmados
    Cuando se renderiza "PageMisContactos"
    Entonces el sistema debe mostrar el texto "Aún no tienes contactos confirmados."
    Y no debe mostrar ninguna tarjeta de contacto

  Escenario: Cada contacto muestra avatar, nombre y acciones
    Dado que el usuario tiene contactos confirmados
    Cuando se renderiza la lista de contactos
    Entonces cada contacto debe mostrar un "CircleAvatar" con la inicial del nombre
    Y debe mostrar el nombre completo como título
    Y debe mostrar un botón "person_search" para ver el perfil del contacto
    Y debe mostrar un botón "chat" para abrir el chat privado

  Escenario: El usuario puede ver el perfil de un contacto
    Dado que el usuario está en "PageMisContactos"
    Cuando el usuario presiona el botón "person_search" de un contacto
    Entonces el sistema debe navegar a "PagePerfilContacto" con "contactoId" y "contactoName"
    Y la navegación debe ser "Navigator.push" con "MaterialPageRoute"

  Escenario: El usuario puede abrir el chat privado con un contacto
    Dado que el usuario está en "PageMisContactos"
    Cuando el usuario presiona el botón "chat" de un contacto
    Entonces el sistema debe navegar a "PageChatPrivado" con "currentUserId", "targetUserId" y "targetName"
    Y la navegación debe ser "Navigator.push" con "MaterialPageRoute"

  Escenario: El usuario puede refrescar la lista de contactos
    Dado que el usuario está en "PageMisContactos"
    Cuando el usuario hace pull-to-refresh en la lista
    Entonces el sistema debe ejecutar "conocidosProvider.notifier.cargar(currentUserId)"
    Y la lista debe actualizarse con los datos más recientes

  Escenario: Las tarjetas de contacto tienen estilo consistente
    Dado que el usuario está viendo la lista de contactos
    Cuando se renderiza una tarjeta de contacto
    Entonces la tarjeta debe tener "color: appTheme.surface" y "elevation: 1"
    Y el título debe tener "fontWeight: bold" y "color: appTheme.onSurface"
    Y el avatar debe tener "backgroundColor: appTheme.secondary"
