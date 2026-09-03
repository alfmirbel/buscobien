# language: es
Característica: Ficha de Captura de Propiedad
  Como promotor
  Quiero ver la ficha de mi propiedad con sus datos, fotos y acciones
  Para gestionar su publicación y edición

  Antecedentes:
    Dado que el usuario es promotor
    Y tiene propiedades registradas en el sistema
    Y se encuentra en la pantalla "Tus Espacios"

  Escenario: Visualización de tarjeta de propiedad
    Dado que el promotor tiene propiedades
    Cuando el sistema carga la lista de propiedades
    Entonces el sistema deberá mostrar una tarjeta por cada propiedad
    Y cada tarjeta deberá mostrar el tipo de propiedad
    Y el nombre de la propiedad
    Y la ubicación (asentamiento, municipio, C.P.)
    Y el precio
    Y la foto principal

  Escenario: Propiedad sin foto principal
    Dado que una propiedad no tiene foto principal
    Cuando el sistema carga la tarjeta de la propiedad
    Entonces el sistema deberá mostrar el texto "Agrega fotos" en el lugar de la foto

  Escenario: Indicador de publicación - propiedad publicada
    Dado que la propiedad está activa (activa = 1)
    Cuando el usuario visualiza la tarjeta
    Entonces el sistema deberá mostrar el ícono de visibilidad (visibility)
    Y el texto "PUBLICADA" en color blanco

  Escenario: Indicador de publicación - propiedad sin publicar
    Dado que la propiedad no está activa (activa = 0)
    Cuando el usuario visualiza la tarjeta
    Entonces el sistema deberá mostrar el ícono de visibilidad desactivada (visibility_off)
    Y el texto "SIN PUBLICAR" en color blanco

  Escenario: Botón Modificar habilitado
    Dado que el usuario visualiza una propiedad
    Cuando el usuario presiona el botón "Modificar"
    Entonces el sistema deberá navegar a la pantalla de edición de la propiedad

  Escenario: Botón Publicar habilitado para propiedad sin publicar
    Dado que la propiedad tiene activa = 0
    Cuando el usuario presiona el botón "Publicar"
    Entonces el sistema deberá mostrar el diálogo de confirmación de publicación

  Escenario: Botón Dejar de publicar habilitado para propiedad publicada
    Dado que la propiedad tiene activa = 1
    Cuando el usuario presiona el botón "Dejar de publicar"
    Entonces el sistema deberá mostrar el diálogo de confirmación de borrado de publicación

  Escenario: Botón Dejar de publicar deshabilitado para propiedad sin publicar
    Dado que la propiedad tiene activa = 0
    Cuando el usuario visualiza el botón "Dejar de publicar"
    Entonces el sistema deberá mostrar el botón con estilo deshabilitado (color secundario)
    Y el sistema deberá impedir la acción de dejar de publicar

  Escenario: Botón Eliminar espacio para propiedad sin publicar
    Dado que la propiedad tiene activa = 0
    Cuando el usuario presiona "Eliminar el espacio de publicación"
    Entonces el sistema deberá mostrar el diálogo de confirmación de eliminación

  Escenario: Botón Eliminar espacio bloqueado para propiedad publicada
    Dado que la propiedad tiene activa = 1
    Cuando el usuario presiona "Eliminar el espacio de publicación"
    Entonces el sistema deberá mostrar un mensaje de aviso "Para borrar el espacio debes dejar de publicarlo"

  Escenario: Navegación a galería de fotos
    Dado que el usuario visualiza la foto principal de una propiedad
    Cuando el usuario presiona sobre la foto
    Entonces el sistema deberá navegar a la pantalla de fotos de la propiedad

  Escenario: Ampliar foto de propiedad
    Dado que el usuario visualiza la tarjeta de propiedad
    Cuando el usuario presiona el ícono de ampliar (fullscreen)
    Entonces el sistema deberá navegar a la pantalla de detalle de la propiedad en modo pantalla completa

  Escenario: Visualización de características expandibles
    Dado que el usuario visualiza la tarjeta de propiedad
    Cuando el usuario presiona "Características"
    Entonces el sistema deberá mostrar las características de la propiedad:
      | caracteristica                    |
      | Mantenimiento                     |
      | Terreno                           |
      | Construcción                      |
      | Recamaras                         |
      | Cuarto de Servicio                |
      | Baños                             |
      | Medios Baños                      |
      | Estacionamientos                  |
      | Cubiertos                         |
      | Ubicación                         |
      | Pais                              |
      | Estado                            |
      | Municipio                         |
      | Ciudad                            |
      | Zona                              |
      | C.P.                              |
      | Calle                             |
      | Num. Exterior                     |
      | Num. Interior                     |

  Escenario: Visualización de datos de contacto expandibles
    Dado que el usuario presiona "Datos del contacto"
    Entonces el sistema deberá mostrar:
      | campo               |
      | Nombre              |
      | Compañia            |
      | Teléfono            |
      | Correo              |

  Escenario: Visualización de datos adicionales
    Dado que el usuario presiona "Datos adicionales"
    Entonces el sistema deberá mostrar las características adicionales según el tipo de propiedad
