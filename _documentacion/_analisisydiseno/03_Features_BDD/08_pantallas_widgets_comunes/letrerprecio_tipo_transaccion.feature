# language: es
# encoding: utf-8
# Fuente: ingeniería inversa `lib/08_pantallas/widgets_comunes/widget_letrero_tipo_transaccion.dart`

Característica: Letrero de precio según tipo de transacción
  Como visitante del catálogo de propiedades
  Quiero ver de un vistazo el tipo de transacción y el precio
  Para identificar rápidamente si la propiedad es de venta, renta, ambas o traspaso

  Antecedentes:
    Dado que existe un ValueEspaciosCasaGet con tipodetransaccion "<tipo>"
    Y su moneda es "MXN"

  Esquema del escenario: Render correcto del letrero según tipo de transacción
    Cuando se renderiza el widget letrerprecio con la lista
    Entonces el texto debe ser "<texto esperado>"
    Y el estilo debe tener fontSize 12
    Y el color debe ser appTheme.onPrimaryContainer

    Ejemplos:
      | tipo          | texto esperado                                          |
      | Venta         | Venta: 1500000 MXN                                      |
      | Renta         | Renta: 18000 MXN                                        |
      | Venta/Renta   | Venta/Renta: 18000/1500000 MXN                          |
      | Traspaso      | Traspaso: 1200000 MXN                                   |

  Escenario: Tipo de transacción desconocido produce Text vacío
    Dado que existe un ValueEspaciosCasaGet con tipodetransaccion "Otro"
    Cuando se renderiza el widget letrerprecio con la lista
    Entonces el texto debe ser ""
    Y no debe lanzar excepción

  Escenario: Precio formateado con separadores de miles
    Dado que existe un ValueEspaciosCasaGet con tipodetransaccion "Venta"
    Y precioventa es 2500000
    Cuando se renderiza el widget letrerprecio con la lista
    Entonces debe mostrar "Venta: 2500000 MXN"
    # NOTA: el widget NO aplica formato de miles — solo concatena el número crudo

  Escenario: Letrero aparece en cada card del catálogo
    Dado que el usuario está en el inicio con 5 propiedades en la primera página
    Cuando la primera página termina de cargar
    Entonces cada WrapModernCard debe incluir un Text de letrerprecio
    Y el Text debe tener fontWeight bold

  Escenario: Estilo consistente con appTheme global
    Dado que el usuario cambió el tema a "darkINE"
    Cuando se renderiza el widget letrerprecio
    Entonces el color debe provenir de appTheme.onPrimaryContainer vigente
