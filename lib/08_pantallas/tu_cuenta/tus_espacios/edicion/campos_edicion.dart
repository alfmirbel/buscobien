import '../../../../60_global_widgets/campo_texto.dart';
import '../tabla_tipopropiedad_vs_campos.dart';

/// Definición declarativa de los campos del formulario de edición de una propiedad.
/// Sustituye a los ~900 renglones repetitivos que había en cada paso del Stepper:
/// el orden de la lista es el orden en pantalla y [visibleEn] aplica las matrices
/// por tipo de inmueble (`tabla_tipopropiedad_vs_campos.dart`) y por tipo de transacción.
class CampoDef {
  /// Nombre del campo en `EspaciosCasa` (lo usan `getCampoEspaciosCasasGet` / `setCampoEspaciosCasasGet`).
  final String nombre;
  final TipoCampo tipo;
  final int? maxLength;
  final bool editable;
  final bool obligatorio;
  final int lineas;

  /// Si es `true` el campo se activa con una casilla (datos adicionales: valor «si»).
  final bool conCasilla;

  /// Tipos de inmueble en los que aplica el campo; `null` = todos.
  final List<String>? matriz;

  /// Tipos de transacción en los que aplica el campo; `null` = todos.
  final List<String>? transacciones;

  const CampoDef(
    this.nombre, {
    this.tipo = TipoCampo.texto,
    this.maxLength,
    this.editable = true,
    this.obligatorio = false,
    this.lineas = 1,
    this.conCasilla = false,
    this.matriz,
    this.transacciones,
  });

  bool visibleEn(String tipoDePropiedad, String tipoDeTransaccion) =>
      (matriz == null || matriz!.contains(tipoDePropiedad)) &&
      (transacciones == null || transacciones!.contains(tipoDeTransaccion));
}

/// Filtra [campos] según el tipo de inmueble y de transacción elegidos.
List<CampoDef> camposVisibles(List<CampoDef> campos, String tipoDePropiedad,
        String tipoDeTransaccion) =>
    campos
        .where((c) => c.visibleEn(tipoDePropiedad, tipoDeTransaccion))
        .toList();

final List<CampoDef> camposPropiedad = [
  CampoDef('clavedelapropiedad', maxLength: 20),
  CampoDef('tipodeanuncio', maxLength: 50, editable: false),
  CampoDef('tipodetransaccion', maxLength: 50),
  CampoDef('nombredelapropiedad', maxLength: 50, obligatorio: true),
  CampoDef('inmobiliaria'),
  CampoDef('inmobiliariaimagen', tipo: TipoCampo.url),
  CampoDef('linkinmobiliaria', tipo: TipoCampo.url),
  CampoDef('sloganinmobiliaria'),
  CampoDef('ubicaciongeneral'),
  CampoDef('descripcion', lineas: 4),
  CampoDef('letreropromocional', lineas: 2),
  CampoDef('metrosdeterreno',
      tipo: TipoCampo.decimal, matriz: metrosdeterrenoMatriz),
  CampoDef('metrosconstruidos',
      tipo: TipoCampo.decimal, matriz: metrosconstruidosMatriz),
  CampoDef('recamaras', tipo: TipoCampo.entero, matriz: recamarasMatriz),
  CampoDef('banos', tipo: TipoCampo.entero, matriz: banosMatriz),
  CampoDef('mediosbanos', tipo: TipoCampo.entero, matriz: mediosbanosMatriz),
  CampoDef('cuartosdeservicio',
      tipo: TipoCampo.entero, matriz: cuartosdeservicioMatriz),
  CampoDef('estacionamientos',
      tipo: TipoCampo.entero, matriz: estacionamientosMatriz),
  CampoDef('estacionamientoscubiertos',
      tipo: TipoCampo.entero, matriz: estacionamientoscubiertosMatriz),
  CampoDef('elementosadicionalescasa',
      maxLength: 250, lineas: 4, matriz: elementosadicionalescasaMatriz),
];

final List<CampoDef> camposPrecio = [
  CampoDef('precioventa',
      tipo: TipoCampo.dinero,
      matriz: precioventaMatriz,
      transacciones: const ['Venta', 'Venta/Renta', 'Traspaso']),
  CampoDef('preciorenta',
      tipo: TipoCampo.dinero,
      matriz: preciorentaMatriz,
      transacciones: const ['Renta', 'Venta/Renta']),
  CampoDef('mantenimiento',
      tipo: TipoCampo.dinero,
      matriz: mantenimientoMatriz,
      transacciones: const ['Renta', 'Venta/Renta']),
  CampoDef('moneda', maxLength: 30, matriz: monedaMatriz),
  CampoDef('condicionesdeventa', maxLength: 30),
  CampoDef('linkvideo', tipo: TipoCampo.url, matriz: linkvideoMatriz),
];

final List<CampoDef> camposUbicacion = [
  CampoDef('pais', maxLength: 30, editable: false),
  CampoDef('estado', maxLength: 30),
  CampoDef('municipio', maxLength: 30),
  CampoDef('ciudad', maxLength: 30),
  CampoDef('zona', maxLength: 30),
  CampoDef('asentamiento', maxLength: 30),
  CampoDef('codigopostal', tipo: TipoCampo.codigoPostal),
  CampoDef('tipo', maxLength: 30),
  CampoDef('calle', maxLength: 30),
  CampoDef('numeroexterior', maxLength: 30),
  CampoDef('numerointerior', maxLength: 30),
  CampoDef('entrecalle01', maxLength: 30),
  CampoDef('entrecalle02', maxLength: 30),
  CampoDef('latitud', maxLength: 30),
  CampoDef('longitud', maxLength: 30),
  CampoDef('latitudDecimal', tipo: TipoCampo.latitud),
  CampoDef('longitudDecimal', tipo: TipoCampo.longitud),
];

final List<CampoDef> camposAdicionales = [
  CampoDef('panelessolares', conCasilla: true, matriz: panelessolaresMatriz),
  CampoDef('jardin', conCasilla: true, matriz: jardinMatriz),
  CampoDef('alberca', conCasilla: true, matriz: albercaMatriz),
  CampoDef('calefaccion', conCasilla: true, matriz: calefaccionMatriz),
  CampoDef('aireacondicionado',
      conCasilla: true, matriz: aireacondicionadoMatriz),
  CampoDef('seguridad', conCasilla: true, matriz: seguridadMatriz),
  CampoDef('enfraccionamiento',
      conCasilla: true, matriz: enfraccionamientoMatriz),
  CampoDef('casasenelconjunto',
      conCasilla: true, matriz: casasenelconjuntoMatriz),
  CampoDef('casaclub', conCasilla: true, matriz: casaclubMatriz),
  CampoDef('salondeeventos', conCasilla: true, matriz: salondeeventosMatriz),
  CampoDef('centrodenegocios',
      conCasilla: true, matriz: centrodenegociosMatriz),
  CampoDef('gimnacio', conCasilla: true, matriz: gimnacioMatriz),
  CampoDef('cisterna', conCasilla: true, matriz: cisternaMatriz),
  CampoDef('almacenamientodeagua',
      conCasilla: true, matriz: almacenamientodeaguaMatriz),
  CampoDef('tratamientodeaguas',
      conCasilla: true, matriz: tratamientodeaguasMatriz),
  CampoDef('otrascaracteristicas',
      conCasilla: true, matriz: otrascaracteristicasMatriz),
];

final List<CampoDef> camposContacto = [
  CampoDef('nombre', maxLength: 30),
  CampoDef('empresa', maxLength: 30),
  CampoDef('imgendeempresa', tipo: TipoCampo.url),
  CampoDef('numerocelular', tipo: TipoCampo.telefono),
  CampoDef('numerootro', tipo: TipoCampo.telefono),
  CampoDef('numeroinmobiliaria', tipo: TipoCampo.telefono),
  CampoDef('correoelectronico', tipo: TipoCampo.correo),
  CampoDef('nombreusuariocontacto', maxLength: 30),
  CampoDef('imgendelcontacto', tipo: TipoCampo.url),
];

/// Todos los campos del formulario, en el orden de los pasos.
final List<CampoDef> todosLosCampos = [
  ...camposPropiedad,
  ...camposPrecio,
  ...camposUbicacion,
  ...camposAdicionales,
  ...camposContacto
];
