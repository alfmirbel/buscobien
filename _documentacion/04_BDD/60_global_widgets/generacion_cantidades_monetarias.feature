# language: es
Característica: Generación de Cantidades Monetarias
  Como usuario final
  Quiero ver cantidades monetarias formateadas aleatoriamente
  Para mostrar rangos de precios en propiedades inmobiliarias

  Escenario: Generar cantidad en millones
    Dado que el sistema necesita mostrar un monto en millones
    Y el rango solicitado es mínimo 2 y máximo 10
    Cuando el sistema ejecuta `generaCantidad("millones", 2, 10)`
    Entonces el sistema retorna un número entre 2 y 10 millones
    Y el formato es "X,XXX,XXX" (millones,miles,cientos)

  Escenario: Generar cantidad en miles
    Dado que el sistema necesita mostrar un monto en miles
    Y el rango solicitado es mínimo 100 y máximo 500
    Cuando el sistema ejecuta `generaCantidad("miles", 100, 500)`
    Entonces el sistema retorna un número entre 100 y 500 mil
    Y el formato es "XXX,XXX" (miles,cientos)

  Escenario: Generar cantidad en cientos
    Dado que el sistema necesita mostrar un monto en cientos
    Y el rango solicitado es mínimo 50 y máximo 200
    Cuando el sistema ejecuta `generaCantidad("cientos", 50, 200)`
    Entonces el sistema retorna un número entre 50 y 200
    Y el formato es "XXX" (solo cientos)

  Escenario: Formatear cantidad mayor a 999999 como millones
    Dado que el sistema necesita formatear el monto 2500000
    Cuando el sistema ejecuta `formatoCantidad(2500000)`
    Entonces el sistema detecta que es mayor a 999999
    Y clasifica como "millones"
    Y retorna "2,500,000"

  Escenario: Formatear cantidad mayor a 999 como miles
    Dado que el sistema necesita formatear el monto 15000
    Cuando el sistema ejecuta `formatoCantidad(15000)`
    Entonces el sistema detecta que es mayor a 999 pero menor a 999999
    Y clasifica como "miles"
    Y retorna "15,000"

  Escenario: Formatear cantidad menor a 1000 como cientos
    Dado que el sistema necesita formatear el monto 850
    Cuando el sistema ejecuta `formatoCantidad(850)`
    Entonces el sistema detecta que es menor a 1000
    Y clasifica como "cientos"
    Y retorna "850"

  Escenario: Relleno con ceros en miles
    Dado que el sistema genera un monto de 1050 pesos
    Cuando el sistema formatea como "miles"
    Entonces el sistema divide en 1 mil y 050 cientos
    Y retorna "1,050" con cero relleno en cientos

  Escenario: Relleno con ceros en millones
    Dado que el sistema genera un monto de 2005000 pesos
    Cuando el sistema formatea como "millones"
    Entonces el sistema divide en 2 millones, 005 mil y 000 cientos
    Y retorna "2,005,000" con ceros de relleno
