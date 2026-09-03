# language: es
Característica: Visualización de Precios por Tipo de Transacción
  Como usuario de BuscoBien
  Quiero ver el precio de una propiedad formateado según su tipo de transacción
  Para entender rápidamente el costo del inmueble

  Escenario: Mostrar precio para propiedad en Venta
    Dado que el usuario está viendo una propiedad con "tipodetransaccion = Venta"
    Y "precioventa = 2500000"
    Y "moneda = MXN"
    Cuando se renderiza "letrerprecio"
    Entonces el sistema debe mostrar el texto "Venta: 2500000 MXN"
    Y el texto debe tener fontSize 12, fontWeight bold y color "appTheme.onPrimaryContainer"

  Escenario: Mostrar precio para propiedad en Renta
    Dado que el usuario está viendo una propiedad con "tipodetransaccion = Renta"
    Y "preciorenta = 15000"
    Y "moneda = MXN"
    Cuando se renderiza "letrerprecio"
    Entonces el sistema debe mostrar el texto "Renta: 15000 MXN"
    Y el texto debe tener fontSize 12, fontWeight bold y color "appTheme.onPrimaryContainer"

  Escenario: Mostrar precio para propiedad en Venta/Renta
    Dado que el usuario está viendo una propiedad con "tipodetransaccion = Venta/Renta"
    Y "precioventa = 3000000"
    Y "preciorenta = 20000"
    Y "moneda = MXN"
    Cuando se renderiza "letrerprecio"
    Entonces el sistema debe mostrar el texto "Venta/Renta: 20000/3000000 MXN"
    Y el texto debe tener fontSize 12, fontWeight bold y color "appTheme.onPrimaryContainer"

  Escenario: Mostrar precio para propiedad en Traspaso
    Dado que el usuario está viendo una propiedad con "tipodetransaccion = Traspaso"
    Y "precioventa = 1800000"
    Y "moneda = MXN"
    Cuando se renderiza "letrerprecio"
    Entonces el sistema debe mostrar el texto "Traspaso: 1800000 MXN"
    Y el texto debe mostrar el precio de venta para traspasos
    Y el texto debe tener fontSize 12, fontWeight bold y color "appTheme.onPrimaryContainer"

  Escenario: El widget usa el precio de venta para traspasos
    Dado que la propiedad tiene "tipodetransaccion = Traspaso"
    Y tiene definidos "precioventa" y "preciorenta"
    Cuando se renderiza "letrerprecio"
    Entonces el sistema debe mostrar el valor de "precioventa" y no el de "preciorenta"
