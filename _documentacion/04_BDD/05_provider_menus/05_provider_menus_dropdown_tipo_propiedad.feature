# language: es
Característica: Dropdown de Tipo de Propiedad
  Como usuario de BuscoBien
  Quiero seleccionar el tipo de inmueble al publicar una propiedad
  Para clasificar correctamente mi anuncio

  Escenario: El dropdown muestra la lista completa de tipos de inmueble
    Dado que el usuario está en la pantalla de publicar propiedad
    Y el parámetro `listaamostrar` es true
    Cuando se renderiza el DropdownButtonPropiedad
    Entonces el sistema debe mostrar la lista completa `listaTipoInmuebles`
    Y debe mostrar el valor inicial seleccionado

  Escenario: El dropdown muestra la lista reducida de tipos de inmueble
    Dado que el usuario está en la pantalla de publicar propiedad
    Y el parámetro `listaamostrar` es false
    Cuando se renderiza el DropdownButtonPropiedad
    Entonces el sistema debe mostrar la lista reducida `otrosTiposDeInmueble`
    Y debe mostrar el valor inicial seleccionado

  Escenario: El usuario selecciona un tipo de propiedad del dropdown
    Dado que el usuario está en la pantalla de publicar propiedad
    Y el dropdown está abierto
    Cuando el usuario selecciona "Casa" del dropdown
    Entonces el sistema debe actualizar `_currentValue` a "Casa"
    Y debe actualizar `selectedDropDownMenuPrincipalValue` a "Casa"
    Y debe ejecutar el callback `onChangedCallback` con el valor "Casa"

  Escenario: El dropdown no se actualiza si el valor es nulo
    Dado que el usuario está en la pantalla de publicar propiedad
    Cuando el dropdown recibe un valor nulo en `onChanged`
    Entonces el sistema no debe actualizar `_currentValue`
    Y no debe actualizar `selectedDropDownMenuPrincipalValue`
    Y no debe ejecutar el callback `onChangedCallback`

  Escenario: El dropdown refleja cambios en el valor inicial
    Dado que el usuario está en la pantalla de publicar propiedad
    Y el dropdown tiene un valor inicial "Departamento"
    Cuando el padre cambia `valorInicial` a "Casa"
    Entonces el sistema debe actualizar `_currentValue` a "Casa"
    Y el dropdown debe mostrar "Casa" como valor seleccionado

  Escenario: El dropdown muestra icono de flecha hacia abajo
    Dado que el usuario está en la pantalla de publicar propiedad
    Cuando se renderiza el DropdownButtonPropiedad
    Entonces el sistema debe mostrar un icono `Symbols.arrow_drop_down`
    Y el icono debe tener tamaño `menuTabIconSize * 2`
    Y el color del icono debe ser `appTheme.primary`

  Escenario: El dropdown usa el color del tema para los items
    Dado que el usuario abre el dropdown de tipo de propiedad
    Cuando se renderiza la lista de opciones
    Entonces cada item debe tener el texto en color `appTheme.primary`
    Y el fondo del dropdown debe ser `appTheme.onPrimary`

  Escenario: El dropdown se inicializa con la lista correcta
    Dado que el widget DropdownButtonPropiedad se crea
    Cuando se ejecuta `initState`
    Entonces el sistema debe establecer `_currentValue` a `widget.valorInicial`
    Y debe cargar `listaTipoInmueble` según el valor de `listaamostrar`
