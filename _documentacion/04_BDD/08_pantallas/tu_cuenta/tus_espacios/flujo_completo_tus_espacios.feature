# language: es
Característica: Flujos Completos del Módulo Tus Espacios
  Como promotor o usuario de BuscoBien
  Quiero interactuar con todas las funcionalidades del módulo
  Para gestionar mis propiedades y espacios publicitarios

  Antecedentes:
    Dado que el usuario "Juan Pérez" es un promotor registrado en BuscoBien
    Y su ID de usuario es "user-juan-123"

  Escenario: Flujo completo de registro de propiedad y publicación
    Dado que Juan es promotor
    Y no tiene propiedades registradas
    Y ha comprado espacios publicitarios
    Cuando Juan navega a "Tus Espacios"
    Y presiona "Modificar" en una propiedad vacía
    Y completa el Stepper de edición:
      | paso   | campo                    | valor                        |
      | 1      | Tipo de propiedad        | Casa                         |
      | 1      | Tipo de transacción      | Venta                        |
      | 1      | Nombre de la propiedad   | Casa en Colonia Roma         |
      | 1      | Descripción              | Amplia casa con jardín       |
      | 2      | Precio de venta          | 2500000                      |
      | 2      | Moneda                   | MXN                          |
      | 3      | Estado                   | Ciudad de México             |
      | 3      | Municipio                | Miguel Hidalgo               |
      | 3      | Calle                    | Av. Reforma                  |
      | 4      | Jardín                   | si                           |
      | 5      | Nombre                   | Juan Pérez                   |
      | 5      | Teléfono                 | 5555555555                   |
    Y presiona "Guardar"
    Entonces el sistema deberá guardar la propiedad en CouchDB
    Y mostrar el mensaje "Se actualizó correctamente"
    Y cerrar el formulario de edición
    Cuando Juan presiona "Publicar"
    Entonces el sistema deberá publicar la propiedad
    Y mostrar el indicador "PUBLICADA" en la tarjeta

  Escenario: Flujo de compra de espacios y creación automática
    Dado que Juan es promotor
    Y no tiene espacios disponibles
    Cuando Juan navega a "Compra de Espacios"
    Y completa el formulario:
      | campo                        | valor |
      | No. de espacios Normales     | 5     |
      | Total espacio Normal         | 500   |
      | Impuestos                    | 80    |
      | Gran Total                   | 580   |
      | Medio de pago                | Transferencia |
      | Referencia de pago           | REF12345 |
    Y presiona "Comprar"
    Entonces el sistema deberá registrar la compra en CouchDB
    Y crear 5 documentos de espacio normal
    Y cada espacio deberá tener un ID de propiedad único generado con SHA1

  Escenario: Flujo de edición de propiedad existente
    Dado que Juan tiene una propiedad publicada "Casa en Roma"
    Cuando Juan presiona "Modificar"
    Y cambia el precio de venta a 3000000
    Y presiona "Guardar"
    Entonces el sistema deberá actualizar la propiedad en CouchDB
    Y mostrar el mensaje "Se actualizó correctamente"
    Y la propiedad deberá mantener su estado de publicación

  Escenario: Flujo de dejar de publicar y volver a publicar
    Dado que Juan tiene una propiedad publicada "Casa en Roma"
    Cuando Juan presiona "Dejar de publicar"
    Y confirma la acción
    Entonces el sistema deberá eliminar la publicación
    Y mostrar "SIN PUBLICAR" en la tarjeta
    Cuando Juan presiona "Publicar"
    Entonces el sistema deberá volver a publicar la propiedad
    Y mostrar "PUBLICADA" en la tarjeta

  Escenario: Flujo de eliminación de propiedad
    Dado que Juan tiene una propiedad sin publicar
    Cuando Juan presiona "Eliminar el espacio de publicación"
    Y confirma la eliminación
    Entonces el sistema deberá eliminar la propiedad de CouchDB
    Y la propiedad deberá desaparecer de la lista

  Escenario: Flujo de navegación entre vistas de usuario
    Dado que un usuario invitado abre "Tus Espacios"
    Cuando presiona "Ingresa como usuario para ver propiedades"
    Entonces el sistema deberá mostrar el diálogo de login
    Cuando el usuario inicia sesión como usuario normal
    Entonces el sistema deberá mostrar "Propiedades guardadas" con lista vacía
    Cuando el usuario cierra sesión e inicia sesión como promotor
    Entonces el sistema deberá mostrar la vista de promotor con botón "Compra de espacios"
