# language: es

Característica: Gestión de Espacios del Promotor (Mis Espacios)
  Como promotor autenticado en BuscoBien
  Quiero administrar mis propiedades publicadas (espacios)
  Para mantener actualizada mi oferta inmobiliaria y gestionar las publicaciones

  Antecedentes:
    Dado que el usuario ha iniciado sesión con perfil "Promotor"
    Y está en la sección "Mi Cuenta" (indiceInicial = 3)
    Y la pestaña activa es "Espacios" (indiceMiCuenta = 0)

  # ---------------------------------------------------------------------------
  # VISUALIZACIÓN DE ESPACIOS DEL PROMOTOR
  # ---------------------------------------------------------------------------
  Escenario: El promotor ve la lista de sus espacios publicados
    Dado que el promotor tiene espacios registrados en la plataforma
    Cuando accede a la pestaña "Espacios"
    Entonces la pantalla "PaginaTusEspacios" debe mostrar la lista de propiedades del promotor
    Y cada propiedad debe mostrar: título, tipo, estado y opciones de gestión

  Escenario: El promotor no tiene espacios registrados aún
    Dado que el promotor no ha publicado ningún espacio
    Cuando accede a la pestaña "Espacios"
    Entonces la pantalla debe mostrar un mensaje indicando que no hay espacios aún
    Y debe mostrar una opción para crear un nuevo espacio

  # ---------------------------------------------------------------------------
  # EDICIÓN DE UN ESPACIO
  # ---------------------------------------------------------------------------
  Escenario: El promotor edita la información de un espacio existente
    Dado que el promotor está viendo la lista de sus espacios
    Cuando selecciona la opción "Editar" en un espacio específico
    Entonces el sistema debe navegar a la ruta "/editaespacio"
    Y debe pasar el objeto "ValueEspaciosCasaGet" del espacio seleccionado como argumento
    Y el formulario de edición debe pre-cargar todos los datos actuales del espacio

  Escenario: El promotor guarda los cambios de un espacio editado
    Dado que el promotor está en el formulario de edición de un espacio
    Y modifica el precio y la descripción del espacio
    Cuando presiona el botón "Guardar cambios"
    Entonces el sistema debe enviar la actualización al servidor vía API
    Y mostrar un indicador de progreso mientras se procesa
    Cuando el servidor confirma la actualización
    Entonces debe mostrar un mensaje de éxito
    Y el espacio debe actualizarse en la lista con los nuevos datos

  # ---------------------------------------------------------------------------
  # GESTIÓN DE FOTOS DE UNA PROPIEDAD
  # ---------------------------------------------------------------------------
  Escenario: El promotor gestiona las fotos de un espacio
    Dado que el promotor está en la lista de sus espacios
    Cuando selecciona la opción de "Fotos" de un espacio
    Entonces el sistema debe navegar a la ruta "/gestionfotopropiedad"
    Y debe mostrar las fotos actuales del espacio en formato de lista

  Escenario: El promotor agrega múltiples fotos a un espacio
    Dado que el promotor está en la pantalla de gestión de fotos
    Cuando presiona "Agregar fotos"
    Entonces el sistema debe navegar a la ruta "/agregamultiplesfotos"
    Y debe permitir seleccionar múltiples imágenes del dispositivo
    Cuando el promotor confirma la selección
    Entonces las fotos deben subirse al servidor
    Y aparecer en la galería del espacio

  Escenario: El promotor ve el carrusel de fotos de su espacio
    Dado que el promotor está en la lista de fotos de un espacio
    Cuando presiona la vista de "Carrusel"
    Entonces el sistema debe navegar a la ruta "/carouselfotospropiedad"
    Y mostrar todas las fotos del espacio en formato deslizable

  # ---------------------------------------------------------------------------
  # COMPRA DE ESPACIOS DE PUBLICACIÓN
  # ---------------------------------------------------------------------------
  Escenario: El promotor adquiere más cupos de publicación
    Dado que el promotor está en la sección "Mi Cuenta"
    Cuando accede a la opción de "Comprar espacios"
    Entonces el sistema debe navegar a la ruta "/compraespacios"
    Y la pantalla "PaginaCompraEspacios" debe mostrar las opciones disponibles:
      | Tipo de espacio    | Descripción                      |
      | Normales           | Publicación estándar              |
      | Destacados         | Mayor visibilidad                 |
      | Superdestacados    | Máxima visibilidad                |
      | Oportunidades      | Precio especial o urgente         |
      | Remates            | Precio significativamente reducido|

  # ---------------------------------------------------------------------------
  # LISTAS DE PROPIEDADES
  # ---------------------------------------------------------------------------
  Escenario: El promotor gestiona sus listas de propiedades favoritas o guardadas
    Dado que el promotor está en "Mi Cuenta"
    Cuando presiona la pestaña "Listas" (indiceMiCuenta = 1)
    Entonces el sistema debe mostrar "PageMisListas"
    Y debe listar todas las listas de propiedades creadas por el promotor

  # ---------------------------------------------------------------------------
  # GRUPOS Y CONOCIDOS DEL PROMOTOR
  # ---------------------------------------------------------------------------
  Escenario: El promotor accede a sus grupos de trabajo
    Dado que el promotor está en "Mi Cuenta"
    Cuando presiona la pestaña "Grupos" (indiceMiCuenta = 2)
    Entonces el sistema debe mostrar "GruposView"
    Y "GruposView" debe recibir el "currentUserId" y "currentUserName" del sessionProvider

  Escenario: El promotor accede a su red de conocidos
    Dado que el promotor está en "Mi Cuenta"
    Cuando presiona la pestaña "Conocidos" (indiceMiCuenta = 3)
    Entonces el sistema debe mostrar "ConocidosView"
    Y "ConocidosView" debe recibir el "currentUserId" y "currentUserName" del sessionProvider
