# language: es
Característica: Compra de Espacios Publicitarios
  Como promotor
  Quiero comprar espacios publicitarios para mis propiedades
  Para aumentar la visibilidad de mis inmuebles en el portal

  Antecedentes:
    Dado que el usuario es promotor autenticado
    Y se encuentra en la pantalla "Compra de Espacios"

  Escenario: Visualización del formulario de compra
    Dado que el usuario abre la pantalla de compra
    Entonces el sistema deberá mostrar el título "Compra de Espacios"
    Y el sistema deberá mostrar la sección "Número de espacios" con campos para:
      | tipo de espacio              |
      | Normales                     |
      | Destacados                   |
      | Superdestacados              |
      | Oportunidades                |
      | Remates                      |
    Y el sistema deberá mostrar la sección "Costo de los espacios" con campos para:
      | campo                        |
      | Total espacios Normales      |
      | Total espacios Destacados    |
      | Total espacios Superdestacados|
      | Total espacios Oportunidades |
      | Total espacios Remates       |
      | Impuestos (IVA)              |
      | Gran Total                   |
    Y el sistema deberá mostrar la sección "Forma de pago" con campos para:
      | campo                        |
      | Medio de pago                |
      | Referencia de pago           |

  Escenario: Validación de campos obligatorios
    Dado que el usuario se encuentra en la pantalla de compra
    Y hay campos vacíos en el formulario
    Cuando el usuario presiona "Comprar"
    Entonces el sistema deberá mostrar el mensaje "El campo es obligatorio" en los campos vacíos
    Y el sistema deberá impedir el envío del formulario

  Escenario: Compra exitosa de espacios
    Dado que el usuario ha completado todos los campos del formulario
    Y ha especificado al menos un espacio a comprar
    Cuando el usuario presiona "Comprar"
    Entonces el sistema deberá generar un ID de transacción único
    Y guardar el registro de compra en la base de datos buscobien_compra_espacios
    Y crear los espacios comprados en las bases de datos correspondientes:
      | tipo de espacio    | base de datos destino           |
      | Normales           | buscobien_espacios_normales     |
      | Destacados         | buscobien_espacios_destacados   |
      | Superdestacados    | buscobien_espacios_superdestacados|
      | Oportunidades      | buscobien_espacios_oportunidades|
      | Remates            | buscobien_espacios_remates      |
    Y mostrar un mensaje de confirmación con el estado de la operación
    Y cerrar la pantalla de compra

  Escenario: Generación de ID de transacción
    Dado que el usuario inicia una compra
    Cuando el sistema procesa la compra
    Entonces el sistema deberá generar el ID de transacción como:
      | componente                         |
      | ID del usuario                     |
      | Timestamp actual                   |
      | Número aleatorio entre 1000 y 9999 |
    Y el sistema deberá aplicar el hash SHA1 al ID de transacción

  Escenario: Creación de espacios comprados
    Dado que la compra se registró exitosamente
    Y el usuario compró 3 espacios normales
    Cuando el sistema crea los espacios
    Entonces el sistema deberá crear 3 documentos en la base de datos de espacios normales
    Y cada documento deberá tener:
      | campo               | valor                        |
      | idPropiedad         | Hash SHA1 único              |
      | clavedelapropiedad  | 8 caracteres del hash        |
      | idusuario           | ID del usuario comprador     |
      | tipodeanuncio       | normal                       |
      | activa              | 0                            |
    Y cada documento deberá tener datos de publicación, contacto y ubicación vacíos

  Escenario: Cancelar compra
    Dado que el usuario se encuentra en la pantalla de compra
    Cuando el usuario presiona "Cancelar"
    Entonces el sistema deberá cerrar la pantalla sin guardar cambios
    Y no deberá crear ningún espacio

  Escenario: Compra sin espacios
    Dado que el usuario ha dejado todos los campos de cantidad de espacios en 0
    Cuando el usuario presiona "Comprar"
    Entonces el sistema deberá permitir el registro de la compra
    Y no deberá crear ningún espacio nuevo

  Escenario: Error en registro de compra
    Dado que el usuario completa el formulario
    Cuando ocurre un error al guardar la compra en CouchDB
    Entonces el sistema deberá mostrar un mensaje de error
    Y no deberá crear espacios nuevos
