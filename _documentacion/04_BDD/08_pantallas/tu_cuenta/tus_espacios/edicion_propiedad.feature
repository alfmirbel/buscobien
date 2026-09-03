# language: es
Característica: Edición de Propiedad (Stepper)
  Como promotor
  Quiero editar los datos de mi propiedad mediante un formulario por pasos
  Para mantener actualizada la información de mis inmuebles

  Antecedentes:
    Dado que el usuario es promotor
    Y tiene una propiedad registrada
    Y se encuentra en la pantalla de edición de propiedad

  Escenario: Visualización del Stepper de edición
    Dado que el usuario abre la pantalla de edición
    Entonces el sistema deberá mostrar un Stepper con 5 pasos:
      | paso       |
      | Propiedad  |
      | Precio     |
      | Ubicación  |
      | Adicionales|
      | Contacto   |

  Escenario: Paso 1 - Datos de la propiedad
    Dado que el usuario se encuentra en el paso "Propiedad"
    Entonces el sistema deberá mostrar campos para:
      | campo                     |
      | Tipo de propiedad         |
      | Tipo de transacción       |
      | Clave de la propiedad     |
      | Tipo de anuncio           |
      | Nombre de la propiedad    |
      | Inmobiliaria              |
      | Descripción               |
      | Letrero promocional       |
    Y el sistema deberá mostrar campos condicionales según el tipo de propiedad:
      | campo condicional         |
      | Metros de terreno         |
      | Metros construidos        |
      | Recamaras                 |
      | Cuarto de Servicio        |
      | Baños                     |
      | Medios Baños              |
      | Estacionamientos          |
      | Estacionamientos cubiertos|

  Escenario: Paso 2 - Precio y costos
    Dado que el usuario se encuentra en el paso "Precio"
    Entonces el sistema deberá mostrar campos para:
      | campo                     |
      | Precio de venta           |
      | Precio de renta           |
      | Mantenimiento             |
      | Moneda                    |
      | Condiciones de venta      |
      | Video de la propiedad     |
    Y los campos de precio deberán mostrarse según el tipo de transacción:
      | tipo transaccion          | campos visibles                    |
      | Venta                     | Precio de venta                    |
      | Renta                     | Precio de renta, Mantenimiento     |
      | Venta/Renta               | Precio de venta, Precio de renta, Mantenimiento |

  Escenario: Paso 3 - Ubicación
    Dado que el usuario se encuentra en el paso "Ubicación"
    Entonces el sistema deberá mostrar campos para:
      | campo                     |
      | País                      |
      | Estado                    |
      | Municipio                 |
      | Ciudad                    |
      | Zona                      |
      | Asentamiento              |
      | Código postal             |
      | Tipo                      |
      | Calle                     |
      | Número exterior           |
      | Número interior           |
      | Entre calle 01            |
      | Entre calle 02            |
      | Latitud                   |
      | Longitud                  |
      | Latitud Decimal           |
      | Longitud Decimal          |

  Escenario: Paso 4 - Datos adicionales
    Dado que el usuario se encuentra en el paso "Adicionales"
    Entonces el sistema deberá mostrar checkboxes para características según el tipo de propiedad:
      | caracteristica            |
      | Paneles solares           |
      | Jardín                    |
      | Alberca                   |
      | Calefacción               |
      | Aire acondicionado        |
      | Seguridad                 |
      | En fraccionamiento        |
      | Casas en el conjunto      |
      | Casa club                 |
      | Salón de eventos          |
      | Centro de negocios        |
      | Gimnasio                  |
      | Cisterna                  |
      | Almacenamiento de agua    |
      | Tratamiento de aguas      |
      | Otras características     |
    Y al marcar un checkbox, el sistema deberá mostrar el campo de texto correspondiente

  Escenario: Paso 5 - Datos del contacto
    Dado que el usuario se encuentra en el paso "Contacto"
    Entonces el sistema deberá mostrar campos para:
      | campo                     |
      | Nombre                    |
      | Compañia                  |
      | Imagen de la inmobiliaria |
      | Número celular            |
      | Número otro               |
      | Número inmobiliaria       |
      | Correo electrónico        |
      | Nombre usuario contacto   |
      | Imagen del contacto       |

  Escenario: Navegación entre pasos
    Dado que el usuario se encuentra en el paso 1
    Cuando el usuario presiona "Siguiente"
    Entonces el sistema deberá avanzar al paso 2
    Y el paso 1 deberá desactivarse
    Cuando el usuario presiona "Anterior"
    Entonces el sistema deberá retroceder al paso anterior
    Y el paso actual deberá desactivarse

  Escenario: Validación de campos obligatorios
    Dado que el usuario se encuentra en cualquier paso
    Y hay campos obligatorios vacíos
    Cuando el usuario presiona "Guardar"
    Entonces el sistema deberá mostrar errores de validación en los campos vacíos
    Y el sistema deberá impedir el guardado

  Escenario: Guardado exitoso de propiedad
    Dado que el usuario ha completado todos los campos obligatorios
    Cuando el usuario presiona "Guardar"
    Entonces el sistema deberá validar el formulario
    Y actualizar la propiedad en el estado de Riverpod
    Y guardar los cambios en CouchDB
    Y mostrar un mensaje "Se actualizó correctamente"
    Y cerrar la pantalla de edición

  Escenario: Cancelar edición
    Dado que el usuario se encuentra en la pantalla de edición
    Cuando el usuario presiona "Regresar"
    Entonces el sistema deberá cerrar la pantalla sin guardar cambios

  Escenario: Campos de solo lectura
    Dado que un campo está marcado como no editable (enable = false)
    Cuando el usuario visualiza el campo
    Entonces el sistema deberá mostrar el valor como texto con decoración overline
    Y el sistema deberá impedir la edición del campo

  Escenario: Checkbox de datos adicionales
    Dado que el usuario se encuentra en el paso "Adicionales"
    Cuando el usuario marca el checkbox "Jardín"
    Entonces el sistema deberá mostrar el campo de texto para "Jardín"
    Y establecer el valor en "si" en el modelo de datos
    Cuando el usuario desmarca el checkbox "Jardín"
    Entonces el sistema deberá ocultar el campo de texto
    Y establecer el valor en vacío en el modelo de datos
