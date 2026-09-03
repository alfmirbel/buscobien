# language: es
Característica: Pantalla de Inicio de Sesión
  Como usuario final
  Quiero identificar claramente la aplicación en la pantalla de login
  Para confiar que estoy ingresando a la plataforma correcta

  Escenario: Visualización del nombre de la aplicación
    Dado que el usuario abre la pantalla de inicio de sesión
    Cuando el sistema renderiza la pantalla de login
    Entonces el sistema muestra el nombre de la aplicación "buscobien" en la interfaz

  Escenario: Icono de usuario no autenticado
    Dado que el usuario abre la pantalla de inicio de sesión
    Y el usuario no ha iniciado sesión
    Cuando el sistema renderiza el indicador de usuario
    Entonces el sistema muestra el icono `no_accounts` (sin cuentas)
    Y el tooltip asociado indica "Sin usuario"

  Escenario: Icono de usuario autenticado
    Dado que el usuario ha iniciado sesión exitosamente
    Cuando el sistema actualiza el indicador de usuario
    Entonces el sistema cambia el icono a `account_circle` (cuenta de usuario)
    Y el tooltip se actualiza con el nombre del usuario

  Escenario: Color primario de marca en botones de login
    Dado que el usuario está en la pantalla de inicio de sesión
    Cuando el sistema renderiza los botones de acción principal
    Entonces el sistema utiliza el color de marca institucional `loginPrimaryBrand` (#415AA9)
    Y el color se aplica como excepción permitida según las reglas de UI
