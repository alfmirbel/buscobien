# language: es
Característica: Sección "Mi Cuenta" y Vistas por Perfil
  Como usuario autenticado o invitado
  Quiero ver opciones diferentes en "Mi Cuenta" según mi tipo de perfil
  Para acceder a las funciones que corresponden a mi rol en la plataforma

  Escenario: Un usuario sin sesión ve la vista de invitado en "Mi Cuenta"
    Dado que el usuario no ha iniciado sesión (nombrePerfil vacío)
    Cuando el usuario navega a la sección "Mi Cuenta" (índice 3)
    Entonces el sistema debe mostrar el mensaje "Crea listas, grupos o contactos"
    Y debe mostrar un botón con el texto "Ingresa de acuerdo a tu perfil"
    Y el botón debe tener borde de color primario y fondo blanco

  Escenario: El botón de invitado abre el diálogo de login
    Dado que el usuario está en la vista de invitado de "Mi Cuenta"
    Cuando el usuario toca el botón "Ingresa de acuerdo a tu perfil"
    Entonces el sistema debe abrir "dialogBoxFichaLogin"
    Y el foco debe estar listo para seleccionar el tipo de perfil

  Escenario: Un promotor autenticado ve las pestañas de su cuenta
    Dado que el usuario ha iniciado sesión con perfil "Promotor"
    Cuando el usuario navega a "Mi Cuenta"
    Entonces el sistema debe mostrar el sub-menú "MenuSuperiorPaginaTuCuenta"
    Y las pestañas disponibles deben ser "Espacios", "Listas", "Grupos" y "Conocidos"

  Escenario: El promotor navega a "Mis Espacios"
    Dado que el promotor está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Espacios" (indiceMiCuenta = 0)
    Entonces el sistema debe mostrar "PaginaTusEspacios"
    Y el scroll debe estar habilitado para recorrer el contenido

  Escenario: El promotor navega a "Mis Listas"
    Dado que el promotor está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Listas" (indiceMiCuenta = 1)
    Entonces el sistema debe mostrar "PageMisListas"
    Y el scroll debe estar deshabilitado (ajuste a pantalla)

  Escenario: El promotor navega a "Mis Grupos"
    Dado que el promotor está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Grupos" (indiceMiCuenta = 2)
    Entonces el sistema debe mostrar "GruposView" con el userId y userName del promotor

  Escenario: El promotor navega a "Mis Conocidos"
    Dado que el promotor está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Conocidos" (indiceMiCuenta = 3)
    Entonces el sistema debe mostrar "ConocidosView" con el userId y userName del promotor

  Escenario: Un usuario (comprador) autenticado ve las pestañas de su cuenta
    Dado que el usuario ha iniciado sesión con perfil "Usuario"
    Cuando el usuario navega a "Mi Cuenta"
    Entonces el sistema debe mostrar el sub-menú "MenuSuperiorPaginaTuCuentaUsuario"
    Y las pestañas disponibles deben ser "Listas", "Grupos" y "Conocidos"
    Y no debe mostrar la pestaña "Espacios"

  Escenario: El usuario (comprador) navega a "Mis Listas"
    Dado que el usuario comprador está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Listas" (indiceMiCuentaUsuario = 0)
    Entonces el sistema debe mostrar "PageMisListas"

  Escenario: El usuario (comprador) navega a "Mis Grupos"
    Dado que el usuario comprador está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Grupos" (indiceMiCuentaUsuario = 1)
    Entonces el sistema debe mostrar "GruposView" con el userId y userName del usuario

  Escenario: El usuario (comprador) navega a "Mis Conocidos"
    Dado que el usuario comprador está en "Mi Cuenta"
    Cuando el usuario selecciona la pestaña "Conocidos" (indiceMiCuentaUsuario = 2)
    Entonces el sistema debe mostrar "ConocidosView" con el userId y userName del usuario
