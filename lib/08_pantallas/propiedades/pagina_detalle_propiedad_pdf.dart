import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Importa tus modelos y funciones de http existentes
import '../../22_imagenes/tus_espacios_fotos_propiedad/manejo_de_fotos/futures_y_providers/http_funciones_gestion_foto.dart';
import '../inicio/data_espacios_casas_get.dart';

class PdfGeneratorService {
  static Future<void> generarYDescargarPDF(
    ValueEspaciosCasaGet propiedad,
    String idFotoPrincipal,
    List<String> idsGaleria,
  ) async {
    final pdf = pw.Document();
    final espacios = propiedad.espacioscasa;

    // --- 1. CONFIGURACIÓN DEL NOMBRE DEL ARCHIVO ---
    // Limpiamos la clave por si tiene caracteres raros, aunque usualmente son alfanuméricos
    String clave = espacios.clavedelapropiedad;
    String nombreArchivo = "buscobien-$clave.pdf";

    // 1. CARGA DE RECURSOS ASÍNCRONOS (Pre-load)
    // El PDF no soporta FutureBuilder, debemos descargar las imágenes antes.

    // --- 1. CARGAR FUENTES (Esencial para Web y Móvil) ---
    // Usamos PdfGoogleFonts para asegurar que se vean igual en todos lados
    /*
    final fontBase = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fontIcons = await PdfGoogleFonts.materialIcons();
    */
    // --- 2. CARGAR IMÁGENES ---
    // a. Cargar Foto Principal
    Uint8List? mainImageBytes;
    if (idFotoPrincipal.isNotEmpty) {
      try {
        String base64 = await recuperaFotoPorIdFoto(idFotoPrincipal);
        if (base64.isNotEmpty) mainImageBytes = base64Decode(base64);
      } catch (e) {
        print("Error foto principal: $e");
      }
    }

    // b. Galería (Limitamos a 6)
    List<Uint8List> galeriaBytes = [];
    for (var id in idsGaleria.take(12)) {
      try {
        String base64 = await recuperaFotoPorIdFoto(id);
        if (base64.isNotEmpty) galeriaBytes.add(base64Decode(base64));
      } catch (e) {
        print("Error foto galeria: $e");
      }
    }

    // c. Fuente de iconos
    final font = await PdfGoogleFonts.materialIcons();

    // --- 3. CONSTRUCCIÓN DEL DOCUMENTO ---
    pdf.addPage(
      pw.MultiPage(
        // CAMBIO: Usamos formato CARTA (Letter)
        pageFormat: PdfPageFormat.letter,
        // Márgenes estándar (aprox 2 cm)
        margin: const pw.EdgeInsets.all(40),

        // IMPORTANTE: Definir el tema con la fuente base
        build: (pw.Context context) {
          return [
            _buildHeader(espacios.nombredelapropiedad),
            pw.SizedBox(height: 10),
            _buildDescripcion(espacios.letreropromocional),
            pw.SizedBox(height: 10),
            _buildDescripcion(espacios.inmobiliaria),
            pw.SizedBox(height: 10),
            _buildMainImage(mainImageBytes),
            pw.SizedBox(height: 10),
            _buildPrecios(espacios),
            pw.SizedBox(height: 10),
            _buildUbicacion(espacios.ubicacioncasa),
            pw.SizedBox(height: 10),
            _buildContacto(espacios.datosdelcontactocasa),
            pw.SizedBox(height: 10),
            _buildDescripcion(espacios.descripcion),
            pw.SizedBox(height: 10),

            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Clave de propiedad: $clave",
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ),
            pw.NewPage(),

            pw.SizedBox(height: 10),
            _buildDatosGrid(espacios, font),

            pw.SizedBox(height: 10),
            if (galeriaBytes.isNotEmpty) _buildGaleria(galeriaBytes),

            // Pie de página con la clave
            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Clave de propiedad: $clave",
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ),
          ];
        },
      ),
    );

    // --- 4. ACCIÓN FINAL (UNIVERSAL) ---
    // Usamos 'layoutPdf' que funciona nativamente en las 3 plataformas.
    // - Web: Abre el PDF en una nueva pestaña del navegador.
    // - Móvil: Abre la vista previa de impresión (donde se puede guardar o compartir).

    clave = espacios.clavedelapropiedad;
    nombreArchivo = "buscobien-$clave.pdf";

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: nombreArchivo,
    );
  }

  // --- WIDGETS INTERNOS DEL PDF (Equivalentes a tus Widgets de Flutter) ---

  static pw.Widget _buildHeader(String titulo) {
    return pw.Header(
      level: 0,
      child: pw.Center(
        child: pw.Text(
          titulo,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  static pw.Widget _buildDescripcion(String texto) {
    return pw.Text(
      texto,
      style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey800),
      textAlign: pw.TextAlign.justify,
    );
  }

  static pw.Widget _buildMainImage(Uint8List? imageBytes) {
    if (imageBytes == null)
      return pw.SizedBox(
        height: 200,
        child: pw.Center(child: pw.Text("Sin Imagen")),
      );
    return pw.Container(
      height: 250,
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.cover),
    );
  }

  static pw.Widget _buildPrecios(dynamic espacios) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        if (espacios.precioventa != "0" && espacios.precioventa != "")
          pw.Text(
            "Venta: ${espacios.precioventa}",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        if (espacios.preciorenta != "0" && espacios.preciorenta != "")
          pw.Text(
            "Renta: ${espacios.preciorenta}",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
      ],
    );
  }

  static pw.Widget _buildDatosGrid(dynamic espacios, pw.Font iconFont) {
    // Helper para celdas con borde
    pw.Widget celda(String label, String valor, int codePoint) {
      if (valor == "0" || valor == "") return pw.SizedBox();
      return pw.Container(
        width: 150,
        margin: const pw.EdgeInsets.all(5),
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Row(
          children: [
            pw.Icon(pw.IconData(codePoint), font: iconFont, size: 14),
            pw.SizedBox(width: 5),
            pw.Text("$label: $valor", style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    // Codepoints de Material Symbols (aproximados para PDF)
    // 0xe541 = terrain, 0xe88a = home, 0xe5f8 = bed, 0xe2eb = shower
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Características",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Wrap(
          children: [
            celda("Terreno", espacios.metrosdeterreno, 0xf779),
            celda("Construcción", espacios.metrosconstruidos, 0xe88a),
            celda("Recámaras", espacios.recamaras.toString(), 0xefdf),
            celda(
              "Cuartos de servicio",
              espacios.cuartosdeservicio.toString(),
              0xeffc,
            ),
            celda("Baños", espacios.banos.toString(), 0xf061),
            celda("Medios baños", espacios.banos.toString(), 0xf061),
            celda("Estacionamientos", espacios.estacionamientos, 0xe531),
            celda("Cubiertos", espacios.estacionamientos, 0xf011),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildUbicacion(dynamic ubicacion) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Ubicación",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Bullet(text: "${ubicacion.calle} ${ubicacion.numeroexterior}"),
        pw.Bullet(
          text:
              "${ubicacion.localidadCp.asentamiento}, ${ubicacion.localidadCp.ciudad}",
        ),
        pw.Bullet(text: "CP: ${ubicacion.localidadCp.cp}"),
      ],
    );
  }

  static pw.Widget _buildContacto(dynamic contacto) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      color: PdfColors.grey100,
      child: pw.Row(
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Contacto",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(contacto.nombre),
              pw.Text(contacto.numerocelular),
              pw.Text(contacto.correoelectronico),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildGaleria(List<Uint8List> imagenes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Galería",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: imagenes.map((bytes) {
            return pw.Container(
              width: 150,
              height: 100,
              child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
            );
          }).toList(),
        ),
      ],
    );
  }
}
