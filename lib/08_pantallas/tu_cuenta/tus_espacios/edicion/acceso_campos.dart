import '../../../inicio/data_espacios_casas_get.dart';
import '../../../../60_global_widgets/debugprint.dart';

// Acceso por nombre a los campos de una propiedad (`EspaciosCasa`).
// Usado por el formulario de edición (campos de texto y casillas).

//----------------------------------

void setCampoEspaciosCasasGet(
  ValueEspaciosCasaGet propiedad,
  String campo,
  String valor,
) {
  debugPrintLevels(
    2,
    'HTTP setCampoEspaciosCasasGet: campo = $campo, valor: $valor',
  );

  switch (campo) {
    case "id":
      propiedad.id = valor;
      break;
    case "rev":
      propiedad.rev = valor;
      break;

    case "versiondelformato":
      propiedad.espacioscasa.versiondelformato = valor;
      break;
    case "idPropiedad":
      propiedad.espacioscasa.idPropiedad = valor;
      break;
    case "clavedelapropiedad":
      propiedad.espacioscasa.clavedelapropiedad = valor;
      break;
    case "idusuario":
      propiedad.espacioscasa.idusuario = valor;
      break;

    case "tipodeanuncio":
      propiedad.espacioscasa.tipodeanuncio = valor;
      break;
    case "tipodetransaccion":
      propiedad.espacioscasa.tipodetransaccion = valor;
      break;
    case "idTransaccion":
      propiedad.espacioscasa.idTransaccion = valor;
      break;

    case "nombredelapropiedad":
      propiedad.espacioscasa.nombredelapropiedad = valor;
      break;
    case "inmobiliaria":
      propiedad.espacioscasa.inmobiliaria = valor;
      break;
    case "inmobiliariaimagen":
      propiedad.espacioscasa.inmobiliariaimagen = valor;
      break;
    case "linkinmobiliaria":
      propiedad.espacioscasa.linkinmobiliaria = valor;
      break;
    case "sloganinmobiliaria":
      propiedad.espacioscasa.sloganinmobiliaria = valor;
      break;

    case "ubicaciongeneral":
      propiedad.espacioscasa.ubicaciongeneral = valor;
      break;

    case "tipodepropiedad":
      propiedad.espacioscasa.tipodepropiedad = valor;
      break;

    case "descripcion":
      propiedad.espacioscasa.descripcion = valor;
      break;
    case "letreropromocional":
      propiedad.espacioscasa.letreropromocional = valor;
      break;
    case "metrosdeterreno":
      propiedad.espacioscasa.metrosdeterreno = valor;
      break;
    case "metrosconstruidos":
      propiedad.espacioscasa.metrosconstruidos = valor;
      break;
    case "recamaras":
      propiedad.espacioscasa.recamaras = valor;
      break;
    case "banos":
      propiedad.espacioscasa.banos = valor;
      break;
    case "mediosbanos":
      propiedad.espacioscasa.mediosbanos = valor;
      break;
    case "cuartosdeservicio":
      propiedad.espacioscasa.cuartosdeservicio = valor;
      break;
    case "estacionamientos":
      propiedad.espacioscasa.estacionamientos = valor;
      break;
    case "estacionamientoscubiertos":
      propiedad.espacioscasa.estacionamientoscubiertos = valor;
      break;

    case "panelessolares":
      propiedad.espacioscasa.datosadicionalescasa.panelessolares = valor;
      break;
    case "jardin":
      propiedad.espacioscasa.datosadicionalescasa.jardin = valor;
      break;
    case "alberca":
      propiedad.espacioscasa.datosadicionalescasa.alberca = valor;
      break;
    case "calefaccion":
      propiedad.espacioscasa.datosadicionalescasa.calefaccion = valor;
      break;
    case "aireacondicionado":
      propiedad.espacioscasa.datosadicionalescasa.aireacondicionado = valor;
      break;
    case "seguridad":
      propiedad.espacioscasa.datosadicionalescasa.seguridad = valor;
      break;
    case "enfraccionamiento":
      propiedad.espacioscasa.datosadicionalescasa.enfraccionamiento = valor;
      break;
    case "casasenelconjunto":
      propiedad.espacioscasa.datosadicionalescasa.casasenelconjunto = valor;
      break;
    case "casaclub":
      propiedad.espacioscasa.datosadicionalescasa.casaclub = valor;
      break;
    case "salondeeventos":
      propiedad.espacioscasa.datosadicionalescasa.salondeeventos = valor;
      break;
    case "centrodenegocios":
      propiedad.espacioscasa.datosadicionalescasa.centrodenegocios = valor;
      break;
    case "gimnacio":
      propiedad.espacioscasa.datosadicionalescasa.gimnacio = valor;
      break;
    case "cisterna":
      propiedad.espacioscasa.datosadicionalescasa.cisterna = valor;
      break;
    case "almacenamientodeagua":
      propiedad.espacioscasa.datosadicionalescasa.almacenamientodeagua = valor;
      break;
    case "tratamientodeaguas":
      propiedad.espacioscasa.datosadicionalescasa.tratamientodeaguas = valor;
      break;
    case "otrascaracteristicas":
      propiedad.espacioscasa.datosadicionalescasa.otrascaracteristicas = valor;

    case "elementosadicionalescasa":
      propiedad.espacioscasa.elementosadicionalescasa = valor;
      break;

    case "precioventa":
      propiedad.espacioscasa.precioventa = valor;
      break;
    case "preciorenta":
      propiedad.espacioscasa.preciorenta = valor;
      break;
    case "mantenimiento":
      propiedad.espacioscasa.mantenimiento = valor;
      break;
    case "moneda":
      propiedad.espacioscasa.moneda = valor;
      break;

    case "niveldeprioridad":
      propiedad.espacioscasa.niveldeprioridad = valor;
      break;
    case "condicionesdeventa":
      propiedad.espacioscasa.condicionesdeventa = valor;
      break;
    case "fotoprincipal":
      propiedad.espacioscasa.fotoprincipal = valor;
      break;
    case "numerodefotos":
      propiedad.espacioscasa.numerodefotos = valor;
      break;
    case "linkvideo":
      propiedad.espacioscasa.linkvideo = valor;
      break;

    case "nombre":
      propiedad.espacioscasa.datosdelcontactocasa.nombre = valor;
      break;
    case "empresa":
      propiedad.espacioscasa.datosdelcontactocasa.empresa = valor;
      break;
    case "imgendeempresa":
      propiedad.espacioscasa.datosdelcontactocasa.imgendeempresa = valor;
      break;
    case "numerocelular":
      propiedad.espacioscasa.datosdelcontactocasa.numerocelular = valor;
      break;
    case "numerootro":
      propiedad.espacioscasa.datosdelcontactocasa.numerootro = valor;
      break;
    case "numeroinmobiliaria":
      propiedad.espacioscasa.datosdelcontactocasa.numeroinmobiliaria = valor;
      break;
    case "correoelectronico":
      propiedad.espacioscasa.datosdelcontactocasa.correoelectronico = valor;
      break;
    case "idusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.idusuariocontacto = valor;
      break;
    case "nombreusuariocontacto":
      propiedad.espacioscasa.datosdelcontactocasa.nombreusuariocontacto = valor;
      break;
    case "imgendelcontacto":
      propiedad.espacioscasa.datosdelcontactocasa.imgendelcontacto = valor;
      break;

    case "pais":
      propiedad.espacioscasa.ubicacioncasa.pais = valor;
      break;

    // LocalidadCp es @freezed — se usa copyWith para actualizar
    case "idEstado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(idEstado: int.tryParse(valor) ?? 0);
      break;
    case "estado":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(estado: valor);
      break;
    case "idMunicipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(idMunicipio: int.tryParse(valor) ?? 0);
      break;
    case "municipio":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(municipio: valor);
      break;
    case "ciudad":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(ciudad: valor);
      break;
    case "zona":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(zona: valor);
      break;
    case "asentamiento":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(asentamiento: valor);
      break;
    case "codigopostal":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(cp: int.tryParse(valor) ?? 0);
      break;
    case "tipo":
      propiedad.espacioscasa.ubicacioncasa.localidadCp = propiedad
          .espacioscasa.ubicacioncasa.localidadCp
          .copyWith(tipo: valor);
      break;

    case "calle":
      propiedad.espacioscasa.ubicacioncasa.calle = valor;
      break;
    case "numeroexterior":
      propiedad.espacioscasa.ubicacioncasa.numeroexterior = valor;
      break;
    case "numerointerior":
      propiedad.espacioscasa.ubicacioncasa.numerointerior = valor;
      break;
    case "entrecalle01":
      propiedad.espacioscasa.ubicacioncasa.entrecalle01 = valor;
      break;
    case "entrecalle02":
      propiedad.espacioscasa.ubicacioncasa.entrecalle02 = valor;
      break;

    case "latitud":
      propiedad.espacioscasa.ubicacioncasa.latitud = valor;
      break;
    case "longitud":
      propiedad.espacioscasa.ubicacioncasa.longitud = valor;
      break;
    case "latitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.latitudDecimal = valor;
      break;
    case "longitudDecimal":
      propiedad.espacioscasa.ubicacioncasa.longitudDecimal = valor;
      break;

    case "diapublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.dia = int.parse(valor);
      break;
    case "mespublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.mes = int.parse(valor);
      break;
    case "aniopublicacion":
      propiedad.espacioscasa.fechadepublicacioncasa.anio = int.parse(valor);
      break;

    case "diadecierre":
      propiedad.espacioscasa.fechadecierrecasa.dia = int.parse(valor);
      break;
    case "mesdecierre":
      propiedad.espacioscasa.fechadecierrecasa.mes = int.parse(valor);
      break;
    case "aniodecierre":
      propiedad.espacioscasa.fechadecierrecasa.anio = int.parse(valor);
      break;

    case "activa":
      propiedad.espacioscasa.activa = int.parse(valor);
      break;
    case "timestampcasa":
      propiedad.espacioscasa.timestampcasa = valor;
      break;
  }
}

String getCampoEspaciosCasasGet(ValueEspaciosCasaGet propiedad, String campo) {
  // debugPrintLevels(5, 'HTTP getCampoEspaciosCasasGet');

  String variableRegreso = "";
  final varEspaciosCasasGetProvider = propiedad;

  switch (campo) {
    case "id":
      return variableRegreso = varEspaciosCasasGetProvider.id;
    case "rev":
      return variableRegreso = varEspaciosCasasGetProvider.rev;

    case "versiondelformato":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.versiondelformato;
    case "idPropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idPropiedad;
    case "clavedelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.clavedelapropiedad;
    case "idusuario":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idusuario;

    case "tipodeanuncio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodeanuncio;
    case "tipodetransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodetransaccion;
    case "idTransaccion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.idTransaccion;

    case "nombredelapropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.nombredelapropiedad;
    case "inmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliaria;
    case "inmobiliariaimagen":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.inmobiliariaimagen;
    case "linkinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkinmobiliaria;
    case "sloganinmobiliaria":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.sloganinmobiliaria;

    case "ubicaciongeneral":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicaciongeneral;

    case "tipodepropiedad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.tipodepropiedad;
    case "descripcion":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.descripcion;
    case "letreropromocional":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.letreropromocional;
    case "metrosdeterreno":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosdeterreno;
    case "metrosconstruidos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.metrosconstruidos;
    case "recamaras":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.recamaras;
    case "banos":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.banos;
    case "mediosbanos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mediosbanos;
    case "cuartosdeservicio":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.cuartosdeservicio;
    case "estacionamientos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientos;
    case "estacionamientoscubiertos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.estacionamientoscubiertos;

    case "panelessolares":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.panelessolares;
    case "jardin":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.jardin;
    case "alberca":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosadicionalescasa.alberca;
    case "calefaccion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.calefaccion;
    case "aireacondicionado":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.aireacondicionado;
    case "seguridad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.seguridad;
    case "enfraccionamiento":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.enfraccionamiento;
    case "casasenelconjunto":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.casasenelconjunto;
    case "casaclub":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.casaclub;
    case "salondeeventos":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.salondeeventos;
    case "centrodenegocios":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.centrodenegocios;
    case "gimnacio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.gimnacio;
    case "cisterna":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.cisterna;
    case "almacenamientodeagua":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.almacenamientodeagua;
    case "tratamientodeaguas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.tratamientodeaguas;
    case "otrascaracteristicas":
      variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosadicionalescasa.otrascaracteristicas;

    case "elementosadicionalescasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.elementosadicionalescasa;

    case "precioventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.precioventa;
    case "preciorenta":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.preciorenta;
    case "mantenimiento":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.mantenimiento;
    case "moneda":
      return variableRegreso = varEspaciosCasasGetProvider.espacioscasa.moneda;
    case "niveldeprioridad":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.niveldeprioridad;
    case "condicionesdeventa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.condicionesdeventa;
    case "fotoprincipal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.fotoprincipal;
    case "numerodefotos":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.numerodefotos;
    case "linkvideo":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.linkvideo;

    case "nombre":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.nombre;
    case "empresa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.datosdelcontactocasa.empresa;
    case "imgendeempresa":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.imgendeempresa;
    case "numerocelular":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.numerocelular;
    case "numerootro":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.numerootro;
    case "numeroinmobiliaria":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.numeroinmobiliaria;
    case "correoelectronico":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.correoelectronico;
    case "idusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.idusuariocontacto;
    case "nombreusuariocontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.nombreusuariocontacto;
    case "imgendelcontacto":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.datosdelcontactocasa.imgendelcontacto;

    case "pais":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.pais;

    case "idEstado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.idEstado
          .toString();
    case "estado":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.estado;
    case "idMunicipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.idMunicipio
          .toString();
    case "municipio":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.municipio;
    case "ciudad":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.ciudad;
    case "zona":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.zona;
    case "asentamiento":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.asentamiento;
    case "codigopostal":
      // El CP se guarda como entero; se muestra con 5 dígitos (03100, no 3100).
      final cp =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.localidadCp.cp;
      return variableRegreso = cp > 0 ? cp.toString().padLeft(5, '0') : '';
    case "tipo":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.localidadCp.tipo;

    case "calle":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.calle;
    case "numeroexterior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numeroexterior;
    case "numerointerior":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.numerointerior;
    case "entrecalle01":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle01;
    case "entrecalle02":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.entrecalle02;

    case "latitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitud;
    case "longitud":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.longitud;
    case "latitudDecimal":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.ubicacioncasa.latitudDecimal;
    case "longitudDecimal":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.ubicacioncasa.longitudDecimal;

    case "diapublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadepublicacioncasa.dia
          .toStringAsFixed(0);
    case "mespublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadepublicacioncasa.mes
          .toStringAsFixed(0);
    case "aniopublicacion":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadepublicacioncasa.anio
          .toStringAsFixed(0);

    case "diadecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadecierrecasa.dia
          .toStringAsFixed(0);
    case "mesdecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadecierrecasa.mes
          .toStringAsFixed(0);
    case "aniodecierre":
      return variableRegreso = varEspaciosCasasGetProvider
          .espacioscasa.fechadecierrecasa.anio
          .toStringAsFixed(0);

    case "activa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.activa.toStringAsFixed(0);
    case "timestampcasa":
      return variableRegreso =
          varEspaciosCasasGetProvider.espacioscasa.timestampcasa;
  }
  return variableRegreso;
}
