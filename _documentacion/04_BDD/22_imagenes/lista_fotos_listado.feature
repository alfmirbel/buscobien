# language: es
Característica: Gestión de Fotos en Modo Listado
  Como usuario final
  Quiero ver y administrar las fotos de mi propiedad en una lista ordenable
  Para organizar el contenido visual de mi publicación

  Escenario: Carga inicial de lista de fotos en modo listado
    Dado que el usuario abre la gestión de fotos en modo listado
    Y la propiedad tiene 5 fotos registradas
    Cuando el sistema carga los datos iniciales en paralelo
    Entonces el sistema consulta el número de fotos, los IDs de fotos y el orden guardado
    Y muestra el título "Número de fotos: 5" con fondo `appTheme.onPrimary`
    Y renderiza la lista de fotos con thumbnail, nombre de archivo y tamaño

  Escenario: Lista vacía sin fotos
    Dado que el usuario abre la gestión de fotos en modo listado
    Y la propiedad no tiene fotos registradas
    Cuando el sistema carga los datos iniciales
    Entonces el sistema muestra el título "Número de fotos: 0"
    Y muestra el mensaje "Sin fotos para mostrar" centrado

  Escenario: Reordenamiento de fotos por drag and drop
    Dado que el usuario está visualizando la lista de fotos en modo listado
    Y la lista tiene 3 fotos en orden A, B, C
    Cuando el usuario arrastra la foto B a la posición 1
    Entonces el sistema actualiza el orden visual a B, A, C
    Y actualiza las posiciones internas de cada foto (0, 1, 2)
    Y el cambio se refleja inmediatamente en la UI

  Escenario: Guardado del orden de fotos cuando existe orden previo
    Dado que el usuario ha reordenado las fotos en la lista
    Y ya existe un orden guardado en CouchDB
    Cuando el usuario presiona el botón "Guardar"
    Entonces el sistema actualiza el documento de orden en CouchDB
    Y recarga los datos para reflejar el nuevo orden guardado

  Escenario: Guardado del orden de fotos cuando no existe orden previo
    Dado que el usuario ha reordenado las fotos en la lista
    Y no existe un orden guardado en CouchDB
    Cuando el usuario presiona el botón "Guardar"
    Entonces el sistema crea un nuevo documento de orden en CouchDB
    Y recarga los datos para reflejar el nuevo orden guardado

  Escenario: Eliminación de foto con confirmación
    Dado que el usuario está visualizando la lista de fotos
    Y presiona el botón de eliminar (icono `delete`) en la foto 2
    Cuando el sistema muestra el diálogo de confirmación "¿Quieres borrar la foto?"
    Y el usuario presiona "Si"
    Entonces el sistema elimina la foto de CouchDB
    Y muestra el mensaje "Se eliminó la foto correctamente"
    Y actualiza la lista removiendo la foto eliminada
    Y actualiza el contador de fotos

  Escenario: Cancelación de eliminación de foto
    Dado que el usuario está visualizando la lista de fotos
    Y presiona el botón de eliminar en una foto
    Cuando el sistema muestra el diálogo de confirmación
    Y el usuario presiona "No"
    Entonces el sistema cierra el diálogo sin eliminar la foto
    Y la lista permanece sin cambios

  Escenario: Agregar nueva foto desde modo listado
    Dado que el usuario está en la gestión de fotos en modo listado
    Y el usuario está en la sección "Mi cuenta"
    Cuando el usuario presiona el botón "Agregar" (icono `add`)
    Entonces el sistema navega a la ruta `agregamultiplesfotos`
    Y al regresar, recarga la lista de fotos

  Escenario: Refrescar lista de fotos
    Dado que el usuario está visualizando la lista de fotos
    Cuando el usuario presiona el botón "Refrescar" (icono `refresh`)
    Entonces el sistema recarga los datos de fotos y orden desde CouchDB
    Y actualiza la lista visual con los datos más recientes

  Escenario: Visualización de thumbnail de foto en listado
    Dado que el usuario está visualizando la lista de fotos
    Y la foto tiene imagen registrada
    Cuando el sistema renderiza el item de la lista
    Entonces muestra un thumbnail de 80x50 píxeles con la imagen decodificada desde base64
    Y muestra el nombre de archivo con estilo bold
    Y muestra el tamaño en bytes con estilo normal

  Escenario: Visualización de placeholder cuando no hay imagen
    Dado que el usuario está visualizando la lista de fotos
    Y una foto no tiene imagen registrada
    Cuando el sistema renderiza el item de la lista
    Entonces muestra el texto "No se encontró foto" en color `appTheme.primary`
    Y no muestra thumbnail de imagen

  Escenario: Menú inferior solo visible en Mi Cuenta
    Dado que el usuario está en la gestión de fotos en modo listado
    Y la sección actual es "Mi cuenta"
    Cuando el sistema renderiza la pantalla
    Entonces muestra la barra inferior con botones: Agregar, Guardar, Refrescar
    Cuando el usuario está en la gestión de fotos desde otra sección
    Entonces muestra solo el botón "Cancelar" en la barra inferior
