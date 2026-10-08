part of 'ficha_propiedad_card.dart';

// Filas de datos de la tarjeta de la propiedad.
class ConceptoEspacioRow extends StatelessWidget {
  final int index;
  final String concepto;
  final String valor;

  const ConceptoEspacioRow(this.index, this.concepto, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.onPrimary,
      width: 170,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              height: 20,
              color: appTheme.onPrimary,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.centerLeft,
              child: Text(
                "$concepto:",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(1.5),
              alignment: Alignment.centerLeft,
              child: Text(
                valor,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UbicacionEspacioRow extends StatelessWidget {
  final String concepto;
  final String valor;

  const UbicacionEspacioRow(this.concepto, this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.onPrimary,
      width:
          widthCuadroFotoPropiedad, // Asegúrate que esta variable global sea constante o reactiva
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.centerLeft,
              child: Text(
                "$concepto:",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 20,
              color: appTheme.surface,
              padding: const EdgeInsets.all(1.5),
              alignment: Alignment.centerLeft,
              child: Text(
                valor,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: appTheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
