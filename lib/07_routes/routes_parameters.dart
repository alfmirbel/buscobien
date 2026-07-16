import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../08_pantallas/inicio/data_espacios_casas.dart';
import '../08_pantallas/inicio/data_espacios_casas_get.dart';
import '../08_pantallas/ubicacion/data_sepomex_localidades.dart';
import '../08_pantallas/ubicacion/data_localidad_find.dart';

//------------------------------------------------------------------------------
class ResultadoGuardaFoto {
  int statusCode;
  String idFoto;

  ResultadoGuardaFoto({required this.statusCode, required this.idFoto});
}

class ResultSaveFoto {
  ResultadoGuardaFoto resultadoEnFotos;
  int resultadoEnEspacios;

  ResultSaveFoto({
    required this.resultadoEnFotos,
    required this.resultadoEnEspacios,
  });
}
//------------------------------------------------------------------------------

Map<String, int> parameterLocalidad = {"cp": 3100};

Map<String, dynamic> parametrosListaFotos = {
  "skip": 0,
  "limit": 0,
  "idUsuario": "",
  "idPropiedad": "",
  "indiceListaPropiedad": 0,
};

ValueEspaciosCasaGet parameterEditaEspacio = ValueEspaciosCasaGet(
  id: "",
  rev: "",
  espacioscasa: EspaciosCasa(
    versiondelformato: "01.00",
    idPropiedad: "",
    clavedelapropiedad: "",
    idusuario: "",
    tipodeanuncio: "",
    tipodepropiedad: "",
    tipodetransaccion: '',
    idTransaccion: "",
    nombredelapropiedad: "",
    inmobiliaria: "",
    inmobiliariaimagen: "",
    linkinmobiliaria: "",
    sloganinmobiliaria: "",
    ubicaciongeneral: "",
    descripcion: "",
    letreropromocional: "",
    metrosdeterreno: "",
    metrosconstruidos: "",
    recamaras: "",
    banos: "",
    mediosbanos: "",
    cuartosdeservicio: "",
    estacionamientos: "",
    estacionamientoscubiertos: "",
    datosadicionalescasa: Datosadicionalescasa(
      panelessolares: "",
      jardin: "",
      alberca: "",
      calefaccion: "",
      aireacondicionado: "",
      seguridad: "",
      enfraccionamiento: "",
      casasenelconjunto: "",
      casaclub: "",
      salondeeventos: "",
      centrodenegocios: "",
      gimnacio: "",
      cisterna: "",
      almacenamientodeagua: "",
      tratamientodeaguas: "",
      otrascaracteristicas: "",
    ),
    elementosadicionalescasa: "",
    precioventa: "",
    preciorenta: "",
    mantenimiento: "",
    moneda: "",
    niveldeprioridad: "",
    condicionesdeventa: "",
    fotoprincipal: "",
    numerodefotos: "",
    linkvideo: "",
    datosdelcontactocasa: Datosdelcontactocasa(
      nombre: "Juan Alfonso Mireles Belmonte",
      empresa: "",
      imgendeempresa: "",
      numerocelular: "5529553701",
      numerootro: "5529553701",
      numeroinmobiliaria: "5529553701",
      correoelectronico: "amirelesb@gmail.com",
      idusuariocontacto: "",
      nombreusuariocontacto: "",
      imgendelcontacto: "",
    ),
    ubicacioncasa: Ubicacioncasa(
      pais: "",
      localidadCp: LocalidadCp(
        idEstado: 0,
        estado: "",
        idMunicipio: 0,
        municipio: "",
        ciudad: "",
        zona: "",
        cp: 0,
        asentamiento: "",
        tipo: "",
      ),
      calle: "",
      numeroexterior: "",
      numerointerior: "",
      entrecalle01: "",
      entrecalle02: "",
      latitud: "",
      longitud: "",
      latitudDecimal: "",
      longitudDecimal: "",
    ),
    fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    activa: 1,
    timestampcasa: "",
  ),
);

ValueEspaciosCasaGet parameterEditaFotos = ValueEspaciosCasaGet(
  id: "",
  rev: "",
  espacioscasa: EspaciosCasa(
    versiondelformato: "01.00",
    idPropiedad: "",
    clavedelapropiedad: "",
    idusuario: "",
    tipodeanuncio: "",
    tipodepropiedad: "",
    tipodetransaccion: '',
    idTransaccion: "",
    nombredelapropiedad: "",
    inmobiliaria: "",
    inmobiliariaimagen: "",
    linkinmobiliaria: "",
    sloganinmobiliaria: "",
    ubicaciongeneral: "",
    descripcion: "",
    letreropromocional: "",
    metrosdeterreno: "",
    metrosconstruidos: "",
    recamaras: "",
    banos: "",
    mediosbanos: "",
    cuartosdeservicio: "",
    estacionamientos: "",
    estacionamientoscubiertos: "",
    datosadicionalescasa: Datosadicionalescasa(
      panelessolares: "",
      jardin: "",
      alberca: "",
      calefaccion: "",
      aireacondicionado: "",
      seguridad: "",
      enfraccionamiento: "",
      casasenelconjunto: "",
      casaclub: "",
      salondeeventos: "",
      centrodenegocios: "",
      gimnacio: "",
      cisterna: "",
      almacenamientodeagua: "",
      tratamientodeaguas: "",
      otrascaracteristicas: "",
    ),
    elementosadicionalescasa: "",
    precioventa: "",
    preciorenta: "",
    mantenimiento: "",
    moneda: "",
    niveldeprioridad: "",
    condicionesdeventa: "",
    fotoprincipal: "",
    numerodefotos: "",
    linkvideo: "",
    datosdelcontactocasa: Datosdelcontactocasa(
      nombre: "Juan Alfonso Mireles Belmonte",
      empresa: "",
      imgendeempresa: "",
      numerocelular: "5529553701",
      numerootro: "5529553701",
      numeroinmobiliaria: "5529553701",
      correoelectronico: "amirelesb@gmail.com",
      idusuariocontacto: "",
      nombreusuariocontacto: "",
      imgendelcontacto: "",
    ),
    ubicacioncasa: Ubicacioncasa(
      pais: "",
      localidadCp: LocalidadCp(
        idEstado: 0,
        estado: "",
        idMunicipio: 0,
        municipio: "",
        ciudad: "",
        zona: "",
        cp: 0,
        asentamiento: "",
        tipo: "",
      ),
      calle: "",
      numeroexterior: "",
      numerointerior: "",
      entrecalle01: "",
      entrecalle02: "",
      latitud: "",
      longitud: "",
      latitudDecimal: "",
      longitudDecimal: "",
    ),
    fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    activa: 1,
    timestampcasa: "",
  ),
);

class ArgumentsLocalidad {
  int cp;

  ArgumentsLocalidad({required this.cp});

  void setCP(int cp) {
    this.cp = cp;
  }
}

class ArgumentsListaLocalidad {
  FindLocalidadXcp listaLocalidades;
  int cp;

  ArgumentsListaLocalidad({required this.listaLocalidades, required this.cp});

  void setListaLocalidades(FindLocalidadXcp listaLocalidades) {
    this.listaLocalidades = listaLocalidades;
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
ValueEspaciosCasaGet inicializaValueGetCasa = ValueEspaciosCasaGet(
  id: "",
  rev: "",
  espacioscasa: EspaciosCasa(
    versiondelformato: "01.00",
    idPropiedad: "",
    clavedelapropiedad: "",
    idusuario: "",
    tipodeanuncio: "",
    tipodepropiedad: "",
    tipodetransaccion: "",
    idTransaccion: "",
    nombredelapropiedad: "",
    inmobiliaria: "",
    inmobiliariaimagen: "",
    linkinmobiliaria: "",
    sloganinmobiliaria: "",
    ubicaciongeneral: "",
    descripcion: "",
    letreropromocional: "",
    metrosdeterreno: "",
    metrosconstruidos: "",
    recamaras: "",
    banos: "",
    mediosbanos: "",
    cuartosdeservicio: "",
    estacionamientos: "",
    estacionamientoscubiertos: "",
    datosadicionalescasa: Datosadicionalescasa(
      panelessolares: "",
      jardin: "",
      alberca: "",
      calefaccion: "",
      aireacondicionado: "",
      seguridad: "",
      enfraccionamiento: "",
      casasenelconjunto: "",
      casaclub: "",
      salondeeventos: "",
      centrodenegocios: "",
      gimnacio: "",
      cisterna: "",
      almacenamientodeagua: "",
      tratamientodeaguas: "",
      otrascaracteristicas: "",
    ),
    elementosadicionalescasa: "",
    precioventa: "",
    preciorenta: "",
    mantenimiento: "",
    moneda: "",
    niveldeprioridad: "",
    condicionesdeventa: "",
    fotoprincipal: "",
    numerodefotos: "",
    linkvideo: "",
    datosdelcontactocasa: Datosdelcontactocasa(
      nombre: "Juan Alfonso Mireles Belmonte",
      empresa: "",
      imgendeempresa: "",
      numerocelular: "5529553701",
      numerootro: "5529553701",
      numeroinmobiliaria: "5529553701",
      correoelectronico: "amirelesb@gmail.com",
      idusuariocontacto: "",
      nombreusuariocontacto: "",
      imgendelcontacto: "",
    ),
    ubicacioncasa: Ubicacioncasa(
      pais: "",
      localidadCp: LocalidadCp(
        idEstado: 0,
        estado: "",
        idMunicipio: 0,
        municipio: "",
        ciudad: "",
        zona: "",
        cp: 0,
        asentamiento: "",
        tipo: "",
      ),
      calle: "",
      numeroexterior: "",
      numerointerior: "",
      entrecalle01: "",
      entrecalle02: "",
      latitud: "",
      longitud: "",
      latitudDecimal: "",
      longitudDecimal: "",
    ),
    fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
    activa: 1,
    timestampcasa: "",
  ),
);

int parameterFotoPrincipal = 0;

Map<String, ValueEspaciosCasaGet> parameterActualizaEspacio = {
  "getespacio": ValueEspaciosCasaGet(
    id: "",
    rev: "",
    espacioscasa: EspaciosCasa(
      versiondelformato: "01.00",
      idPropiedad: "",
      clavedelapropiedad: "",
      idusuario: "",
      tipodeanuncio: "",
      tipodepropiedad: "",
      tipodetransaccion: "",
      idTransaccion: "",
      nombredelapropiedad: "",
      inmobiliaria: "",
      inmobiliariaimagen: "",
      linkinmobiliaria: "",
      sloganinmobiliaria: "",
      ubicaciongeneral: "",
      descripcion: "",
      letreropromocional: "",
      metrosdeterreno: "",
      metrosconstruidos: "",
      recamaras: "",
      banos: "",
      mediosbanos: "",
      cuartosdeservicio: "",
      estacionamientos: "",
      estacionamientoscubiertos: "",
      datosadicionalescasa: Datosadicionalescasa(
        panelessolares: "",
        jardin: "",
        alberca: "",
        calefaccion: "",
        aireacondicionado: "",
        seguridad: "",
        enfraccionamiento: "",
        casasenelconjunto: "",
        casaclub: "",
        salondeeventos: "",
        centrodenegocios: "",
        gimnacio: "",
        cisterna: "",
        almacenamientodeagua: "",
        tratamientodeaguas: "",
        otrascaracteristicas: "",
      ),
      elementosadicionalescasa: "",
      precioventa: "",
      preciorenta: "",
      mantenimiento: "",
      moneda: "",
      niveldeprioridad: "",
      condicionesdeventa: "",
      fotoprincipal: "",
      numerodefotos: "",
      linkvideo: "",
      datosdelcontactocasa: Datosdelcontactocasa(
        nombre: "Juan Alfonso Mireles Belmonte",
        empresa: "",
        imgendeempresa: "",
        numerocelular: "5529553701",
        numerootro: "5529553701",
        numeroinmobiliaria: "5529553701",
        correoelectronico: "amirelesb@gmail.com",
        idusuariocontacto: "",
        nombreusuariocontacto: "",
        imgendelcontacto: "",
      ),
      ubicacioncasa: Ubicacioncasa(
        pais: "",
        localidadCp: LocalidadCp(
          idEstado: 0,
          estado: "",
          idMunicipio: 0,
          municipio: "",
          ciudad: "",
          zona: "",
          cp: 0,
          asentamiento: "",
          tipo: "",
        ),
        calle: "",
        numeroexterior: "",
        numerointerior: "",
        entrecalle01: "",
        entrecalle02: "",
        latitud: "",
        longitud: "",
        latitudDecimal: "",
        longitudDecimal: "",
      ),
      fechadepublicacioncasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      fechadecierrecasa: Fechadecasa(dia: 0, mes: 0, anio: 0),
      activa: 1,
      timestampcasa: "",
    ),
  ),
};

Map<String, dynamic> parameterPaginaChecaConeccion = {"ref": WidgetRef};

Map<String, dynamic> parameterCapturaFotosCasa = {
  "idUsuario": "",
  "idPropiedad": "",
  "propiedad": ValueEspaciosCasaGet,
  "indexlistafotos": 0,
};

Map<String, int> parameterPaginaMenuTipoTransaccion = {
  "nivelGobierno": 0,
  "tipodepublicacion": 0,
};

Map<String, dynamic> parameterGestionFoto = {
  "idUsuario": "",
  "idPropiedad": "",
  "idFoto": "",
  "propiedad": ValueEspaciosCasaGet,
  "fotoprincipal": bool,
  "indice": 0,
};
